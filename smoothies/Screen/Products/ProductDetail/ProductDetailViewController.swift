//
//  ProductDetailViewController.swift
//  smoothies
//
//  Created by zhen xin  tan ruan on 3/19/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//

import UIKit
import RxSwift

class ProductDetailViewController: BaseViewController {
  
  @IBOutlet weak var ingrendientsButton: SegmentButton!
  @IBOutlet weak var preparationButton: SegmentButton!
  
  @IBOutlet weak var ingredientTableView: UITableView!
  @IBOutlet weak var preparationLabel: UILabel!
  var likeButton: UIButton!

  private var viewModel: ProductDetailViewModelType!
  var productDetailInformationVC: ProductDetailInfomationViewController?
  var productUpdateSignal = PublishSubject<ProductModel>()
  
  internal static func instantiate(viewModel: ProductDetailViewModel) -> ProductDetailViewController {
    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
    vc.viewModel = viewModel
    return vc
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    initView()
    setupBarButtonItem()
    setupSegmentButton()
    setupTableView()
    loadPreparation()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    if segue.identifier == "segueProductDetailInfomationViewController" {
      productDetailInformationVC = segue.destination as? ProductDetailInfomationViewController
      let productDetailInforVM = ProductDetailInfomationViewModel(image: viewModel.product.image,
                                                                  name: viewModel.product.name,
                                                                  rating: viewModel.product.rating ?? 0.0,
                                                                  minute: viewModel.product.time,
                                                                  cate: viewModel.product.cate)
      productDetailInformationVC?.initVC(viewModel: productDetailInforVM)
    }
  }
  
  @IBAction func setupIngredient(_ sender: Any) {
    let setupOrderVM = SetupOrderViewModel(ingredients: viewModel.product.ingredients,
                                           garnishs: viewModel.product.standardGarnish,
                                           drinkWares: viewModel.product.drinkware,
                                           served: viewModel.product.servings,
                                           order: viewModel.createOrderModel())
    let setupOrderVC = SetupOrderViewController.instantiate(viewModel: setupOrderVM)
    navigationController?.pushViewController(setupOrderVC, animated: true)
  }
  
  @objc func backToVC(_ sender: UIButton) {
    navigationController?.popViewController(animated: true)
  }
  
  @objc func likeAction(_ sender: UIButton) {
    showLoadingIndicator()
    viewModel.likeProduct()
  }
  
  @objc func changeSegment(_ sender: UIButton) {
    if sender == ingrendientsButton.button {
      showIngredient()
    } else {
      showPreparation()
    }
  }
  
  func checkLike() -> Bool {
    guard let listId = viewModel.product.userLikes else { return false }
    let userid = UserModel.currentUser.userID
    return listId.contains(userid)
  }
}

extension ProductDetailViewController {
  
  private func initView() {
    navigationItem.title = viewModel.product.name
    
    viewModel.likeSuccessSignal
      .subscribe(onNext: {[weak self] isLike in
        guard let self = self else { return }
        self.hideLoadingIndicator()
        let image = isLike ? UIImage(named: "icon_heart_fill1") : UIImage(named: "icon_heart_empty")
        self.likeButton.setImage(image, for: .normal)
        self.productUpdateSignal.onNext(self.viewModel.product)
      }, onError: nil, onCompleted: nil, onDisposed: nil)
    .disposed(by: disposeBag)
    
    viewModel.likeFailSignal
      .subscribe(onNext: { [weak self] error in
        self?.hideLoadingIndicator()
        self?.view.makeToast(error)
      }, onError: nil, onCompleted: nil, onDisposed: nil)
    .disposed(by: disposeBag)
    
  }
  
  private func setupSegmentButton() {
    ingrendientsButton.setTitleButton("INGREDIENTS")
    ingrendientsButton.button.addTarget(self, action: #selector(changeSegment), for: .touchUpInside)
    
    preparationButton.setTitleButton("PREPARATION")
    preparationButton.button.addTarget(self, action: #selector(changeSegment), for: .touchUpInside)
    
    showIngredient()
  }
  
  private func showIngredient() {
    ingrendientsButton.setSelectedState()
    preparationButton.setUnSelectedState()
    
    ingredientTableView.isHidden = false
    preparationLabel.isHidden = true
  }
  
  private func showPreparation() {
    ingrendientsButton.setUnSelectedState()
    preparationButton.setSelectedState()
    
    ingredientTableView.isHidden = true
    preparationLabel.isHidden = false
  }
}

extension ProductDetailViewController {
  
  private func setupBarButtonItem() {
    setupLeftBarButton()
    setupRightBarButton()
  }
  
  private func setupLeftBarButton() {
    let button = UIButton(type: .custom)
    button.setImage(UIImage(named: "icon_back"), for: .normal)
    button.tintColor = .black
    button.contentHorizontalAlignment = .left
    button.addTarget(self, action: #selector(backToVC), for: .touchUpInside)
    button.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
    button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 20)
    let barButton = UIBarButtonItem(customView: button)
    navigationItem.leftBarButtonItem = barButton
  }
  
  private func setupRightBarButton() {
    likeButton = UIButton(type: .custom)
    likeButton.setImage(UIImage(named: checkLike() ? "icon_heart_fill" : "icon_heart_empty"), for: .normal)
    likeButton.addTarget(self, action: #selector(likeAction), for: .touchUpInside)
    likeButton.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
    likeButton.imageEdgeInsets = UIEdgeInsets(top: 8, left: 17, bottom: 8, right: 0)
    let barButton = UIBarButtonItem(customView: likeButton)
    navigationItem.rightBarButtonItem = barButton
  }
  
  private func setupTableView() {
    let xib = UINib(nibName: "ProductIngredientTableViewCell", bundle: nil)
    ingredientTableView.register(xib, forCellReuseIdentifier: "ProductIngredientTableViewCell")
  }
  
  private func loadPreparation() {
    let attributedString = NSMutableAttributedString(string: viewModel.product.preparation)
    
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = 10
    attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
    preparationLabel.attributedText = attributedString
  }
}

extension ProductDetailViewController: UITableViewDelegate {
  
}

extension ProductDetailViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.ingrendients.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductIngredientTableViewCell", for: indexPath) as? ProductIngredientTableViewCell else { return UITableViewCell() }
    if indexPath.row%2 == 0 {
      cell.backgroundColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1)
    } else {
      cell.backgroundColor = UIColor.white
    }
    cell.loadCell(ingredient: viewModel.ingrendients[indexPath.row])
    return cell
  }
}
