//
//  CustomerInfomationViewController.swift
//  smoothies
//
//  Created by zhen xin  tan ruan on 3/26/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import DropDown
import Toast_Swift

class CustomerInfomationViewController: BaseViewController {
  
  @IBOutlet weak var tableView: UITableView!
  let stateDropDown = DropDown()
  let cityDropDown = DropDown()

  private var viewModel: CustomerInfomationViewModelType!
  
  var images: [UIImage?] = [UIImage(named: "notebook"), UIImage(named: "apartment"), UIImage(named: "usa"), UIImage(named: "signpost"), UIImage(named: "mailbox"), UIImage(named: "telephone")]
  var titles: [String] = ["Address", "Apt/Suite #", "State", "City", "Postal Code", "Phone Number"]
  
  internal static func instantiate(viewModel: CustomerInfomationViewModel) -> CustomerInfomationViewController {
    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CustomerInfomationViewController") as! CustomerInfomationViewController
    vc.viewModel = viewModel
    return vc
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Delivery Information"
    initView()
    setupLeftBarButton()
    setupTableView()
    
  }
  
  func initView() {
    self.stateDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
      self.viewModel.stateSelect = self.viewModel.state[index].statename
      self.viewModel.cities = self.viewModel.state[index].cities
      self.viewModel.citySelect = ""
      self.tableView.reloadData()
    }
    
    self.cityDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
      self.viewModel.citySelect = self.viewModel.cities[index]
      self.tableView.reloadData()
    }
  }
  
  func initVC(viewModel: CustomerInfomationViewModel) {
    self.viewModel = viewModel
  }
  
  private func setupLeftBarButton() {
    let button = UIButton(type: .custom)
    button.setImage(UIImage(named: "icon_back"), for: .normal)
    button.addTarget(self, action: #selector(backToVC), for: .touchUpInside)
    button.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
    button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 20)
    let barButton = UIBarButtonItem(customView: button)
    navigationItem.leftBarButtonItem = barButton
  }
  
  private func setupTableView() {
    let textCell = UINib(nibName: "TextFieldWithIconTableViewCell", bundle: nil)
    tableView.register(textCell, forCellReuseIdentifier: "TextFieldWithIconTableViewCell")
    
    let selectionCell = UINib(nibName: "SelectionTableViewCell", bundle: nil)
    tableView.register(selectionCell, forCellReuseIdentifier: "SelectionTableViewCell")
    
    let confirmOrderCell = UINib(nibName: "ConfirmOrderTableViewCell", bundle: nil)
    tableView.register(confirmOrderCell, forCellReuseIdentifier: "ConfirmOrderTableViewCell")
  }
  
  @objc func backToVC(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }
}

extension CustomerInfomationViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.row == 6 {
      return 80
    }
    return 71
  }
}

extension CustomerInfomationViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return images.count + 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.row {
    case 0:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldWithIconTableViewCell", for: indexPath) as? TextFieldWithIconTableViewCell else { return UITableViewCell() }
      cell.textField.keyboardType = .default
      let title = viewModel.addressVariable.value.isBlank ? titles[indexPath.row] : viewModel.addressVariable.value
      cell.loadData(icon: images[indexPath.row], title: title)
      cell.textField.rx.text.map { $0 ?? "" }.bind(to: viewModel.addressVariable).disposed(by: cell.disposebag)
      return cell
      
    case 1:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldWithIconTableViewCell", for: indexPath) as? TextFieldWithIconTableViewCell else { return UITableViewCell() }
      cell.textField.keyboardType = .default
      let title = viewModel.aptSuiteVariable.value.isBlank ? titles[indexPath.row] : viewModel.aptSuiteVariable.value
      cell.loadData(icon: images[indexPath.row], title: title)
      cell.textField.rx.text.map { $0 ?? "" }.bind(to: viewModel.aptSuiteVariable).disposed(by: cell.disposebag)
      return cell
      
    case 4:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldWithIconTableViewCell", for: indexPath) as? TextFieldWithIconTableViewCell else { return UITableViewCell() }
      cell.textField.keyboardType = .phonePad
      let title = viewModel.postalCodeVariable.value.isBlank ? titles[indexPath.row] : viewModel.postalCodeVariable.value
      cell.loadData(icon: images[indexPath.row], title: title)
      cell.textField.rx.text.map { $0 ?? "" }.bind(to: viewModel.postalCodeVariable).disposed(by: cell.disposebag)
      return cell
      
    case 5:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldWithIconTableViewCell", for: indexPath) as? TextFieldWithIconTableViewCell else { return UITableViewCell() }
      cell.textField.keyboardType = .phonePad
      let title = viewModel.phoneVariable.value.isBlank ? titles[indexPath.row] : viewModel.phoneVariable.value
      cell.loadData(icon: images[indexPath.row], title: title)
      cell.textField.keyboardType = .phonePad
      cell.textField.rx.text.map { $0 ?? "" }.bind(to: viewModel.phoneVariable).disposed(by: cell.disposebag)
      return cell
      
    case 2:
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "SelectionTableViewCell", for: indexPath) as? SelectionTableViewCell else { return UITableViewCell() }
    let title = viewModel.stateSelect.isBlank ? titles[indexPath.row] : viewModel.stateSelect
    cell.loadData(icon: images[indexPath.row], title: title)
    cell.callBack = { [weak self] in
      guard let self = self else { return }
      self.stateDropDown.anchorView = cell.titleLabel
      let dataSource = self.viewModel.state.compactMap({ $0.statename })
      self.stateDropDown.dataSource = dataSource
      self.stateDropDown.show()
    }
    return cell
      
    case 3:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "SelectionTableViewCell", for: indexPath) as? SelectionTableViewCell else { return UITableViewCell() }
      let title = viewModel.citySelect.isBlank ? titles[indexPath.row] : viewModel.citySelect
      cell.loadData(icon: images[indexPath.row], title: title)
      cell.callBack = { [weak self] in
        guard let self = self else { return }
        self.cityDropDown.anchorView = cell.titleLabel
        self.cityDropDown.dataSource = self.viewModel.cities
        self.cityDropDown.show()
      }
      return cell
      
    default:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "ConfirmOrderTableViewCell", for: indexPath) as? ConfirmOrderTableViewCell else { return UITableViewCell() }
      cell.confirmButton.addTarget(self, action: #selector(confirmOrder), for: .touchUpInside)
      return cell
    }
  }
}

extension CustomerInfomationViewController {
  @objc func confirmOrder(_ sender: Any) {
    
    if let message = viewModel.validate() {
      self.view.makeToast(message)
      return
    }
    viewModel.updateOrder()
    
    let confirmOrderVM = ConfirmOrderViewModel(ingredients: viewModel.ingredients, garnishs: viewModel.garnishes, drinkWares: viewModel.drinkwares, order: viewModel.order)
    let vc = ConfirmOrderViewController.instantiate(viewModel: confirmOrderVM)
    navigationController?.pushViewController(vc, animated: true)
  }
}
