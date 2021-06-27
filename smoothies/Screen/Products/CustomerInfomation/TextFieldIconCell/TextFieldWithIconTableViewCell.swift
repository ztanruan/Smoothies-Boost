//
//  TextFieldWithIconTableViewCell.swift
//  smoothies
//
//  Created by zhen xin  tan ruan on 3/26/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//

import RxCocoa
import RxSwift

class TextFieldWithIconTableViewCell: UITableViewCell {
  @IBOutlet weak var iconImageView: UIImageView!
  @IBOutlet weak var textField: UITextField!
  var disposebag = DisposeBag()
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    disposebag = DisposeBag()
  }
  
  func loadData(icon: UIImage?, title: String) {
    iconImageView.image = icon
    textField.placeholder = title
  }
}
