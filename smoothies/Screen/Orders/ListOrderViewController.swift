//
//  ListOrderViewController.swift
//  smoothies
//
//  Created by zhen xin  tan ruan on 3/16/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//

import UIKit

class ListOrderViewController: BaseViewController {
  
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var pageControl: UIPageControl!
  
  private var viewModel: ListOrderViewModelType!
  private var widthCell: CGFloat = 0
  private var heightCell: CGFloat = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    showLoadingIndicator()
    viewModel = ListOrderViewModel()
    initView()
    setupObservable()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.navigationBar.isHidden = false
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    widthCell = collectionView.frame.width - 32
    heightCell = collectionView.frame.height - 32
  }
  
  @IBAction func handleBack(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }
  
  func setupObservable() {
    viewModel.getlistSuccessSignal
      .subscribe(onNext: {[weak self] _ in
        self?.hideLoadingIndicator()
        self?.pageControl.numberOfPages = self?.viewModel.orders.count ?? 0
        self?.collectionView.reloadData()
      }, onError: nil, onCompleted: nil, onDisposed: nil)
    .disposed(by: disposeBag)
    
    viewModel.getlistFailSignal
      .subscribe(onNext: {[weak self] message in
        self?.hideLoadingIndicator()
        self?.view.makeToast(message)
      }, onError: nil, onCompleted: nil, onDisposed: nil)
    .disposed(by: disposeBag)
  }
}

extension ListOrderViewController {
  private func initView() {
    collectionView.register(OrderCollectionViewCell.self)
    pageControl.hidesForSinglePage = true
    pageControl.numberOfPages = 0
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
  }
}

extension ListOrderViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
  }
}

extension ListOrderViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: widthCell, height: heightCell)
  }
}

extension ListOrderViewController: UICollectionViewDataSource {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return viewModel.orders.count
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    self.pageControl.currentPage = indexPath.section
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeuReusableCell(for: indexPath) as OrderCollectionViewCell
    cell.loadData(order: viewModel.orders[indexPath.section])
    return cell
  }
}
