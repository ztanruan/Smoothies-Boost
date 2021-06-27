//
//  MapViewController.swift
//  smoothies
//
//  Created by zhen xin  tan ruan on 4/27/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import SwiftyJSON


// This class will control the Location view controlloer
// This class will display the near close store location in a MapKit
// Keep track and store user location using Mapkit
// This source code tamplate taken from David Tran (Use this template to create Location View Controller)

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var venues = [Venue]()
    
    func fetchData()
    {
        let fileName = Bundle.main.path(forResource: "Venues", ofType: "json")
        let filePath = URL(fileURLWithPath: fileName!)
        var data: Data?
        do {
            data = try Data(contentsOf: filePath, options: Data.ReadingOptions(rawValue: 0))
        } catch let error {
            data = nil
            print("Report error \(error.localizedDescription)")
        }
 
        // Read the json file venue and filter the data and grab the location (coordinates)
        // Map the coordinate into a map and display to the user view controller
        
        if let jsonData = data {
            let json = try! JSON(data: jsonData)
            if let venueJSONs = json["response"]["venues"].array {
                for venueJSON in venueJSONs {
                    if let venue = Venue.from(json: venueJSON) {
                        self.venues.append(venue)
                    }
                }
            }
        }
    }
    
    // MARK: - VC Lifecycle
    
    // The IBAction func will handle the back button for user to go back to th eprevious view controller
    
    @IBAction func handleBack(_sender: Any)
    {
        navigationController?.popViewController(animated: true)
    }
    
    
    // Default Fucntion lo load view controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let initialLocation = CLLocation(latitude: 37.769122, longitude: -122.428353)
        zoomMapOn(location: initialLocation)
        
        mapView.delegate = self
        fetchData()
        mapView.addAnnotations(venues)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkLocationServiceAuthenticationStatus()
    }
    
    // Use CLLocationDistance to obtain user current location
    // Keep track user location and display the most current location
    
    private let regionRadius: CLLocationDistance = 3000 // 1km ~ 1 mile = 1.6km
    func zoomMapOn(location: CLLocation)
    {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    // MARK: - Current Location
    // Func to check user location status
    // Update user location in real time and keep updating it data
    
    var locationManager = CLLocationManager()
    
    func checkLocationServiceAuthenticationStatus()
    {
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    
    //MARK: Show Direction
    
    // Display pin to represent the user current location
    // Show and display direction to the closest store/select by user
    // Map the location/store in the Venues.json file
    
    var currentPlacemark: CLPlacemark?
    
    @IBAction func showDirection(sender: Any)
        
    {
        guard let currentPlacemark = currentPlacemark
            else {
            return
        }
        
        let directionRequest = MKDirections.Request()
        let destionationPlacemark = MKPlacemark(placemark: currentPlacemark)
        
        directionRequest.source = MKMapItem.forCurrentLocation()
        directionRequest.destination = MKMapItem(placemark: destionationPlacemark)
        directionRequest.transportType = .automobile
        
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (directionsResponse, error) in
            guard let directionsResponse =  directionsResponse else {
                if let error = error {
                    print("error getting directions: \(error.localizedDescription)")
                    
                }
                return
            
           }
            
            let route = directionsResponse.routes[0]
            self.mapView.removeOverlays(self.mapView.overlays)
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
            
            let routeRect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(routeRect), animated: true)
            
        }
    }
    
}

    // This function will manager and keep track of the data (latitude and longitude) of user location
    // This function enable user to zoom and scroll around the map

extension MapViewController : CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last!
        self.mapView.showsUserLocation = true
        mapView.isScrollEnabled = true
        mapView.isZoomEnabled = true
        zoomMapOn(location: location)
    }
}



    // Verify that user location is enable
    // Use a pin to mark user current location and update it

extension MapViewController : MKMapViewDelegate
{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        if let annotation = annotation as? Venue {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
            }
            
            return view
        }
        
        return nil
    }

    // Display the map in user view controller
    // Display the locaton of the stores in the venues.json file into the user map

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)
    
    {
        let location = view.annotation as! Venue
        let lauchOptions = [MKLaunchOptionsDirectionsModeKey:
        MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: lauchOptions)
    }

    
    // Func to display user location in the view controller
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
            if let location = view.annotation as? Venue {
            self.currentPlacemark = MKPlacemark(coordinate: location.coordinate)
        }
    }
    
    // Func to display the line to show the direction/path to the selected store from user location
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer
    {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.orange
        renderer.lineWidth = 4.0

        return renderer
    }

}


