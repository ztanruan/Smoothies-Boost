//
//  SetupOrderViewController.swift
//  smoothies
//
//  Created by zhen xin  tan ruan on 3/18/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//

import UIKit

class SetupOrderViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  
  private var viewModel: SetupOrderViewModelType!
  
  internal static func instantiate(viewModel: SetupOrderViewModel) -> SetupOrderViewController {
    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SetupOrderViewController") as! SetupOrderViewController
    vc.viewModel = viewModel
    return vc
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = viewModel.order.name
    setupTableView()
  }
  
  @IBAction func handleBack(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }
  
  func setupTableView() {
    let ingredientCell = UINib(nibName: "IngredientCheckTableViewCell", bundle: nil)
    tableView.register(ingredientCell, forCellReuseIdentifier: "IngredientCheckTableViewCell")
    
    let servingCell = UINib(nibName: "ServingsTableViewCell", bundle: nil)
    tableView.register(servingCell, forCellReuseIdentifier: "ServingsTableViewCell")
    
    let header = UINib(nibName: "IngredientHeaderTableViewCell", bundle: nil)
    tableView.register(header, forCellReuseIdentifier: "IngredientHeaderTableViewCell")
    
    let totalCell = UINib(nibName: "TotalOderPriceTableViewCell", bundle: nil)
    tableView.register(totalCell, forCellReuseIdentifier: "TotalOderPriceTableViewCell")
  }
}

extension SetupOrderViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.row == drinkWareStartIndex() + viewModel.drinkWares.count {
      return 155
    } else {
      return UITableView.automaticDimension
    }
  }
}

extension SetupOrderViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.ingredients.count + viewModel.garnishs.count + viewModel.drinkWares.count + 4
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if isServing(indexPath: indexPath) {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "ServingsTableViewCell", for: indexPath) as? ServingsTableViewCell else { return UITableViewCell() }
      cell.loadCell(served: viewModel.served, defaulValue: viewModel.servingValue)
      cell.callBack = { [weak self] value in
        guard let self = self else { return }
        self.viewModel.servingValue = value
        self.viewModel.order.serving = value
        self.tableView.reloadData()
      }
      return cell
      
    } else if isIngredient(indexPath: indexPath) {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCheckTableViewCell", for: indexPath) as? IngredientCheckTableViewCell else { return UITableViewCell() }
      let beginIndex = 1
      let ingredient = viewModel.ingredients[indexPath.row - beginIndex]
      cell.loadData(data: ingredient, index: indexPath.row - beginIndex)
      cell.callBack = { [weak self] index in
        guard let self = self else { return }
        self.viewModel.ingredients[index].isSelect = !self.viewModel.ingredients[index].isSelect
        self.tableView.reloadData()
      }
      return cell
      
    } else if isGarnish(indexPath: indexPath) {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCheckTableViewCell", for: indexPath) as? IngredientCheckTableViewCell else { return UITableViewCell() }
      let beginIndex = garnishStartIndex()
      let garnish = viewModel.garnishs[indexPath.row - beginIndex]
      cell.loadData(data: garnish, index: indexPath.row - beginIndex)
      cell.callBack = { [weak self] index in
        guard let self = self else { return }
        self.viewModel.garnishs[index].isSelect = !self.viewModel.garnishs[index].isSelect
        self.tableView.reloadData()
      }
      return cell
      
    } else if isDrinkWare(indexPath: indexPath) {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCheckTableViewCell", for: indexPath) as? IngredientCheckTableViewCell else { return UITableViewCell() }
      let beginIndex = drinkWareStartIndex()
      let drinkWare = viewModel.drinkWares[indexPath.row - beginIndex]
      cell.loadData(data: drinkWare, index: indexPath.row - beginIndex)
      cell.callBack = { [weak self] index in
        guard let self = self else { return }
        self.viewModel.drinkWares[index].isSelect = !self.viewModel.drinkWares[index].isSelect
        self.tableView.reloadData()
      }
      return cell
      
    } else if isHeader(indexPath: indexPath) {
      guard let header = tableView.dequeueReusableCell(withIdentifier: "IngredientHeaderTableViewCell", for: indexPath) as? IngredientHeaderTableViewCell else { return UITableViewCell() }
      return header
      
    } else {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "TotalOderPriceTableViewCell", for: indexPath) as? TotalOderPriceTableViewCell else { return UITableViewCell() }
      cell.hidePaymentButton()
      let total = viewModel.totalPrice()
      cell.totalLabel.text = "\(total) USD"
      cell.orderButton.addTarget(self, action: #selector(confirmIngredients), for: .touchUpInside)
      return cell
    }
  }
  
  @objc func confirmIngredients(_ sender: Any) {
    if self.viewModel.ingredients.filter({$0.isSelect}).isEmpty && self.viewModel.garnishs.filter({$0.isSelect}).isEmpty && self.viewModel.drinkWares.filter({$0.isSelect}).isEmpty {
      self.view.makeToast("You need to select ingredients")
      return
    }
    
    self.viewModel.order.price = viewModel.totalPrice()
    let customerInfomationVM = CustomerInfomationViewModel(order: self.viewModel.order,
                                                           ingredients: self.viewModel.ingredients.filter({$0.isSelect}),
                                                           garnishes: self.viewModel.garnishs.filter({$0.isSelect}),
                                                           drinkwares: self.viewModel.drinkWares.filter({$0.isSelect}))
    let vc = CustomerInfomationViewController.instantiate(viewModel: customerInfomationVM)
    self.navigationController?.pushViewController(vc, animated: true)
  }
}

extension SetupOrderViewController {
  
  func isServing(indexPath: IndexPath) -> Bool {
    return indexPath.row == 0
  }
  
  func isIngredient(indexPath: IndexPath) -> Bool {
    return indexPath.row > 0 && indexPath.row <= viewModel.ingredients.count
  }
  
  func isGarnish(indexPath: IndexPath) -> Bool {
    let garnishHeaderIndex = viewModel.ingredients.count + 1
    return indexPath.row > garnishHeaderIndex && indexPath.row <= garnishHeaderIndex + viewModel.garnishs.count
  }
  
  func isDrinkWare(indexPath: IndexPath) -> Bool {
    let garnishIndex = viewModel.ingredients.count + 1
    let drinkWareIndex = garnishIndex + viewModel.garnishs.count + 1
    return indexPath.row > drinkWareIndex && indexPath.row <= drinkWareIndex + viewModel.drinkWares.count
  }
  
  func isHeader(indexPath: IndexPath) -> Bool {
    let garnishIndex = viewModel.ingredients.count + 1
    let drinkWareIndex = garnishIndex + viewModel.garnishs.count + 1
    return indexPath.row == garnishIndex || indexPath.row == drinkWareIndex
  }
  
  func garnishStartIndex() -> Int {
    return 1 + viewModel.ingredients.count + 1
  }
  
  func drinkWareStartIndex() -> Int {
    return 1 + viewModel.ingredients.count + 1 + viewModel.garnishs.count + 1
  }
}
