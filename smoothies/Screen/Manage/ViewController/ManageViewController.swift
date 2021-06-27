// ManageViewController.swift
// smoothies
//
//  Created by zhen xin  tan ruan on 4/23/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//

import UIKit
import DropDown

class ManageViewController: BaseViewController {

  // MARK: - IBOutlet
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var searchBar: UISearchBar!

  let statusDropDown = DropDown()
  var dataSource: [String] {
    return initDropdownsDataSource()
  }
  
  // MARK: - Variables
  private var viewModel: ManageViewModelType!
  
  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    showLoadingIndicator()
    initVC(viewModel: ManageViewModel())
    initView()
    setupObservable()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.navigationBar.isHidden = false
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    layoutView()
  }
  
  @IBAction func handleBack(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }
  
  @IBAction func showFilter(_ sender: UIButton) {
    statusDropDown.anchorView = sender.titleLabel
    statusDropDown.dataSource = dataSource
    statusDropDown.show()
    statusDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
      self.showLoadingIndicator()
      self.viewModel.getlistOrders(status: item)
    }
  }
}

// MARK: - UI
extension ManageViewController {
  func initVC(viewModel: ManageViewModel) {
    self.viewModel = viewModel
  }
  
  private func initView() {
    tableView.rowHeight = UITableView.automaticDimension
    tableView.register(ManageOrderTableViewCell.self)
    
    searchBar.delegate = self
  }
  
  private func setupObservable() {
    viewModel.getlistSuccessSignal
      .subscribe(onNext: { [weak self] _ in
        self?.hideLoadingIndicator()
        self?.tableView.reloadData()
      }, onError: nil, onCompleted: nil, onDisposed: nil)
    .disposed(by: disposeBag)
    
    viewModel.getlistFailSignal
      .subscribe(onNext: { [weak self] message in
        self?.hideLoadingIndicator()
        self?.view.makeToast(message)
      }, onError: nil, onCompleted: nil, onDisposed: nil)
    .disposed(by: disposeBag)
  }
  
  private func layoutView() {
    
  }
  
  private func initDropdownsDataSource() -> [String] {
    let dataSource = [OrderStatus.Processed.rawValue, OrderStatus.Delivered.rawValue, OrderStatus.Shipped.rawValue]
    
    return ["All"] + dataSource
  }
}

extension ManageViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let updateStatusVM = UpdateStatusOrderViewModel(order: viewModel.orders[indexPath.row])
    let vc = UpdateStatusOrderViewController.instantiate(viewModel: updateStatusVM)
    navigationController?.pushViewController(vc, animated: true)
    vc.updateOrderSignal
      .subscribe(onNext: {[weak self] order in
        self?.viewModel.updateOrder(updateOrder: order)
      }, onError: nil, onCompleted: nil, onDisposed: nil)
    .disposed(by: disposeBag)
  }
}

extension ManageViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.orders.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeuReusableCell(for: indexPath) as ManageOrderTableViewCell
    cell.loadData(order: viewModel.orders[indexPath.row])
    return cell
  }
}

extension ManageViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    OrderApi.searchOrders(id: searchText)
      .subscribe(onNext: {[weak self] orders in
        self?.viewModel.orders = orders
        self?.tableView.reloadData()
      }, onError: nil, onCompleted: nil, onDisposed: nil)
    .disposed(by: disposeBag)
  }
}

