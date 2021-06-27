// TutorialViewController.swift
// smoothies
//
//  Created by zhen xin  tan ruan on 4/26/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//

import UIKit

class TutorialViewController: BaseViewController {

  // MARK: - IBOutlet
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var pageControl: UIPageControl!
  
  // MARK: - Variables
  private var widthCell: CGFloat = 0
  private var heightCell: CGFloat = 0
  private var viewModel: TutorialViewModelType!
  
  // MARK: - View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initVC(viewModel: TutorialViewModel())
    initView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    layoutView()
  }
  
  @IBAction func handleContinue(_ sender: Any) {
    let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController")
    let navigationVC = UINavigationController(rootViewController: vc)
    appDelegate.changeRootVC(vc: navigationVC, animation: true)
  }
}

// MARK: - UI
extension TutorialViewController {
  private func initView() {
    collectionView.register(TutorialCollectionViewCell.self)
    pageControl.hidesForSinglePage = true
    pageControl.numberOfPages = viewModel.tutorials.count
  }
  
  private func layoutView() {
    widthCell = collectionView.bounds.width - 60
    heightCell = collectionView.bounds.height
  }
  
  private func initVC(viewModel: TutorialViewModel) {
    self.viewModel = viewModel
  }
}

extension TutorialViewController {
  
}

extension TutorialViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
  }
}

extension TutorialViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: widthCell, height: heightCell)
  }
}

extension TutorialViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return viewModel.tutorials.count
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    self.pageControl.currentPage = indexPath.section
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeuReusableCell(for: indexPath) as TutorialCollectionViewCell
    cell.loadCell(item: viewModel.tutorials[indexPath.section])
    return cell
  }
}
