//
//  SlideMenuViewController.swift
//  smoothies
//
//  Created by zhen xin  tan ruan on 4/26/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//

import RxCocoa
import RxSwift

class SlideMenuViewController: BaseViewController {
  
  @IBOutlet weak var avatarImageView: UIImageView!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var emailLabel: UILabel!

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet private weak var leadingSlideMenuViewConstraint: NSLayoutConstraint!
  @IBOutlet private weak var slideMenuView: UIView!
  
  var itemSlideMenuTypePublishSignal: PublishSubject = PublishSubject<ItemSlideMenu>()
  var slideMenuHiddenPublishSignal: PublishSubject = PublishSubject<Void>()
  private var viewModel: SlideMenuViewModelType!
  private var coveringStatusBarWindow: UIWindow?
  private lazy var bannerView : UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.white
    return view
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initView()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    let touch: UITouch? = touches.first
    if touch?.view == view {
      hiddenSlideMenu()
    }
  }
}

extension SlideMenuViewController {
  private func initView() {    
    leadingSlideMenuViewConstraint.constant = -Constants.ScreenSize.width * Constants.SlideMenu.ratio
    bannerView.frame = CGRect(x: -Constants.ScreenSize.width * Constants.SlideMenu.ratio, y: 0, width: Constants.ScreenSize.width * Constants.SlideMenu.ratio, height: UIApplication.shared.statusBarFrame.height)
    
    tableView.register(ItemSlideMenuTableViewCell.self)
    tableView.rowHeight = UITableView.automaticDimension
    
    let user = UserModel.currentUser
    usernameLabel.text = user.username
    emailLabel.text = user.email
    avatarImageView.loadImage(fromUrl: URL(string: UserModel.currentUser.avatar), placeholder: UIImage(named: "user_default"))
  }
  
  private func layoutView() {
    
  }
  
  func initVC(viewModel: SlideMenuViewModel) {
    self.viewModel = viewModel
  }
  
  // MARK: Do something
  func showSlideMenuViewWithAnimation() {
    coveringStatusBarWindow = UIWindow(frame: CGRect(x: 0,
                                                     y: 0,
                                                     width: Constants.ScreenSize.width * Constants.SlideMenu.ratio,
                                                     height: UIApplication.shared.statusBarFrame.height))
    UIView.animate(withDuration: 0.4) {
      if let coveringWindow = self.coveringStatusBarWindow {
        coveringWindow.windowLevel = UIWindow.Level.statusBar + 1
        coveringWindow.isHidden = false
      }
      self.bannerView.frame.origin.x = 0
      self.coveringStatusBarWindow?.backgroundColor = UIColor.clear
      self.coveringStatusBarWindow?.addSubview(self.bannerView)
      self.coveringStatusBarWindow?.makeKeyAndVisible()
      self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
      self.leadingSlideMenuViewConstraint.constant = 0
      self.view.layoutIfNeeded()
    }
  }
  
  private func hiddenSlideMenu() {
    self.hiddenSlideMenuViewWithAnimation {
      self.slideMenuHiddenPublishSignal.onNext(())
      self.dismiss(animated: false, completion: nil)
    }
  }
  
  func hiddenSlideMenuViewWithAnimation(done: @escaping (()->Void)) {
    UIView.animate(withDuration: 0.4, animations: {
      self.bannerView.frame.origin.x = -Constants.ScreenSize.width * Constants.SlideMenu.ratio
      
      self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
      self.leadingSlideMenuViewConstraint.constant = -Constants.ScreenSize.width * Constants.SlideMenu.ratio
      self.view.layoutIfNeeded()
    }) { result in
      self.bannerView.removeFromSuperview()
      self.coveringStatusBarWindow = nil
      done()
    }
  }
}

extension SlideMenuViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if !viewModel.itemSlideMenus[indexPath.row].isActive {
      viewModel.itemSlideMenus.forEach { (item) in
        item.isActive = false
      }
      viewModel.itemSlideMenus[indexPath.row].isActive = true
      
      self.hiddenSlideMenuViewWithAnimation {
        self.dismiss(animated: false, completion: {
          self.itemSlideMenuTypePublishSignal.onNext(self.viewModel.itemSlideMenus[indexPath.row])
        })
      }
    } else {
      self.hiddenSlideMenu()
    }
  }
}

extension SlideMenuViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.itemSlideMenus.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeuReusableCell(for: indexPath) as ItemSlideMenuTableViewCell
    cell.loadData(item: viewModel.itemSlideMenus[indexPath.row])
    return cell
  }
}
