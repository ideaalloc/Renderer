//
// Created by Bill Lv on 2018/8/30.
// Copyright (c) 2018 Atlas Protocol. All rights reserved.
//

import Foundation
import UIKit
import Validator

public class ValidationTextField: UITextField, UITextFieldDelegate {
  lazy var bottomBorder: CALayer = {
    let border = CALayer();
    let width = CGFloat(1.0)
    // border.borderColor = UIColor.black.cgColor
    border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: self.frame.size.height)
    border.borderWidth = width
    self.layer.addSublayer(border)
    self.layer.masksToBounds = true
    return border
  }()

  var isValid: Bool?

  var validationRuleSet: ValidationRuleSet<String>? {
    didSet {
      self.validationRules = validationRuleSet
    }
  }

  public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }

  public override func awakeFromNib() {
    super.awakeFromNib()
    self.validateOnInputChange(enabled: true)
  }

  required public init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
    delegate = self
    self.isUserInteractionEnabled = true
    self.attributedPlaceholder = NSAttributedString(text: "NAS Address", alignment: .center)
    self.font = UIFont.systemFont(ofSize: 14.0, weight: UIFont.Weight.regular)
    self.borderStyle = UITextBorderStyle.roundedRect
  }

  required override public init(frame: CGRect) {
    super.init(frame: frame)
    delegate = self
    self.isUserInteractionEnabled = true
    self.attributedPlaceholder = NSAttributedString(text: "NAS Address", alignment: .center)
    self.font = UIFont.systemFont(ofSize: 14.0, weight: UIFont.Weight.regular)
    self.borderStyle = UITextBorderStyle.roundedRect
  }

  override public func layoutSubviews() {
    super.layoutSubviews();
    var borderColor: UIColor?
    if isValid == nil {
      borderColor = UIColor.gray
    } else if isValid! {
      borderColor = UIColor.gray
    } else {
      borderColor = UIColor.red
    }

    bottomBorder.borderColor = borderColor!.cgColor
  }

  func createBorder() {
    let border = CALayer()
    let width = CGFloat(2.0)
    // border.borderColor = UIColor.black.cgColor
    border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: self.frame.size.height)
    border.borderWidth = width
    self.layer.addSublayer(border)
    self.layer.masksToBounds = true
  }

  public func setValid(isValid: Bool) {
    self.isValid = isValid
  }

  public func textFieldDidBeginEditing(_ textField: UITextField) {
    print("focused")
  }

  public func textFieldDidEndEditing(_ textField: UITextField) {
    print("lost focus")
  }

}

extension NSAttributedString {
  convenience init(text: String, alignment: NSTextAlignment) {
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = alignment
    self.init(string: text, attributes: [NSAttributedStringKey.paragraphStyle: paragraphStyle])
  }
}
