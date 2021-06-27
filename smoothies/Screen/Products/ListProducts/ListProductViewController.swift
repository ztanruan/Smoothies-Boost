//
//  ListProductViewController.swift
//  smoothie
//
//  Created by zhen xin  tan ruan on 3/14/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//

import RxSwift
import RxCocoa

class ListProductViewController: BaseViewController {
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  private var viewModel: ListProductsViewModelType!
  
  var topSafeArea: CGFloat = 0.0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Smoothies"
    showLoadingIndicator()
    initVC(viewModel: ListProductsViewModel())
    setupView()
    setupNoti()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    topSafeArea = view.safeAreaInsets.top
    collectionView.reloadData()
  }
  
  @IBAction func handleShowSlideMenu(_ sender: Any) {
    let vc = SlideMenuViewController(nibName: "SlideMenuViewController", bundle: nil)
    vc.modalPresentationStyle = .overFullScreen
    vc.modalTransitionStyle = .crossDissolve
    let slideMenuViewModel = SlideMenuViewModel(type: .smoothies)
    vc.initVC(viewModel: slideMenuViewModel)
    
    vc.itemSlideMenuTypePublishSignal
      .subscribe(onNext: { [weak self] (item) in
        guard let self = self else { return }
        if item.type == .signout {
          AuthenApi.signout()
          self.signOut()
        } else {
          let vc = item.type.getVC()
          self.navigationController?.pushViewController(vc, animated: false)
        }
        }, onError: nil, onCompleted: nil, onDisposed: nil)
      .disposed(by: vc.disposeBag)
    present(vc, animated: false, completion: {
      vc.showSlideMenuViewWithAnimation()
    })
  }
}
extension ListProductViewController {
  private func setupNoti() {
    NotificationCenter.default.addObserver(self, selector: #selector(openListOrders(noti:)), name: Notification.Name("finishOrder"), object: nil)
  }

  @objc func openListOrders(noti: Notification) {
    let vc = ItemSlideMenuType.myorder.getVC()
    self.navigationController?.pushViewController(vc, animated: false)
  }
  
  private func signOut() {
    let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController")
    let navigationVC = UINavigationController(rootViewController: vc)
    appDelegate.changeRootVC(vc: navigationVC, animation: true)
  }
  
  private func initVC(viewModel: ListProductsViewModel) {
    self.viewModel = viewModel
    
    viewModel.getListSuccessSignal
      .subscribe(onNext: {[weak self] _ in
        self?.hideLoadingIndicator()
        self?.collectionView.reloadData()
        }, onError: nil, onCompleted: nil, onDisposed: nil)
      .disposed(by: disposeBag)
    
    viewModel.getListErrorSignal
      .subscribe(onNext: {[weak self] errorMessage in
        self?.hideLoadingIndicator()
        self?.view.makeToast(errorMessage)
      }, onError: nil, onCompleted: nil, onDisposed: nil)
      .disposed(by: disposeBag)
  }
  
  private func setupView() {
    let cell = UINib(nibName: "ProductCollectionViewCell", bundle: nil)
    collectionView.register(cell, forCellWithReuseIdentifier: "ProductCollectionViewCell")
    
    let layout = UICollectionViewFlowLayout()
    let screenSize = UIScreen.main.bounds
    layout.itemSize = CGSize(width: screenSize.width, height: screenSize.height)
    collectionView.collectionViewLayout = layout
    
    collectionView.isPagingEnabled = true
  }
}

extension ListProductViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: view.frame.width, height: view.frame.height)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
  }
}

extension ListProductViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.products.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as? ProductCollectionViewCell else { return UICollectionViewCell() }
    cell.loadCell(product: viewModel.products[indexPath.row])
    cell.detailButton.tag = indexPath.row
    cell.detailButton.addTarget(self, action: #selector(showDetail(_:)), for: .touchUpInside)
    return cell
  }
  
  @objc func showDetail(_ sender: UIButton) {
    let productDetailVM = ProductDetailViewModel(product: viewModel.products[sender.tag])
    let detailVC = ProductDetailViewController.instantiate(viewModel: productDetailVM)
    navigationController?.pushViewController(detailVC, animated: true)
    
    detailVC.productUpdateSignal
      .subscribe(onNext: {[weak self] product in
        self?.viewModel.updateProduct(product)
        
      }, onError: nil, onCompleted: nil, onDisposed: nil)
    .disposed(by: disposeBag)
  }
}
