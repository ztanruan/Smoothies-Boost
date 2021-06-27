//
//  Venue.swift
//  smoothies
//
//  Created by zhen xin  tan ruan on 4/27/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//

import Foundation
import MapKit
import AddressBook
import SwiftyJSON


    // This class read the json file that contains the stores locations
    // It will read and filter the coordinate and display it into user view controller
    // Reference :  Template from David Tran

class Venue: NSObject, MKAnnotation
{
    let title: String?
    let locationName: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String?, coordinate: CLLocationCoordinate2D)
    {
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
    
    // Convert the json file to be able to read it and querry the data
    
    class func from(json: JSON) -> Venue?
    {
        var title: String
        if let unwrappedTitle = json["name"].string {
            title = unwrappedTitle
        } else {
            title = ""
        }
        
        
        // Filter the dictionary and grab the address, location, state, city, postalcode
        // Display the information in the user view controller
        
        var locationName = json["location"]["address"].string!
        locationName += ", "
        locationName += json["location"]["city"].string!
        locationName += ", "
        locationName += json["location"]["state"].string!
        locationName += " "
        locationName += json["location"]["postalCode"].string!
        
        let lat = json["location"]["lat"].doubleValue
        let long = json["location"]["lng"].doubleValue
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        return Venue(title: title, locationName: locationName, coordinate: coordinate)
    }
    
    
    // Func display location details on the user view controller
    // Display the information about the place
    
    func mapItem() -> MKMapItem
    {
        let addressDictionary = [String(kABPersonAddressStreetKey) : subtitle]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
        let mapItem = MKMapItem(placemark: placemark)
        
        mapItem.name = "\(title) \(subtitle)"
        
        return mapItem
    }
}
