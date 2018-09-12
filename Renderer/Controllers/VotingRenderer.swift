//
//  VotingRenderer.swift
//  Renderer
//
//  Created by Bill Lv on 2018/8/31.
//  Copyright © 2018 Atlas Protocol. All rights reserved.
//

import UIKit
import DLRadioButton
import Validator
import Foundation

open class VotingRenderer: UIViewController, ATPRenderer {
  // MARK: - IBOutlet
  @IBOutlet var toolbar: UIToolbar!

  // MARK: - Private Variables
  fileprivate var allProjects = [String]()

  fileprivate var currentIndex = -1
  fileprivate var headButton: DLRadioButton?

  fileprivate var nasAddress: String?
  fileprivate var question: String?

  public func render() {
    setComponents()

    NotificationCenter.default.addObserver(self, selector: Selector.saveCurrentState
        , name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
  }

  public func emitEvent(atpEvent: ATPEvent) {
    let option: String = atpEvent as! String
    let sv = VotingRenderer.displaySpinner(onView: self.view)
    do {
      try vote(Vote(nasAddress: nasAddress!, campaignID: getCampaignID(), answer: option), completion: { responseString in
        VotingRenderer.removeSpinner(spinner: sv)
        let data = responseString?.data(using: .utf8)

        if let respData = data,
           let decodedResp = try? JSONSerialization.jsonObject(with: respData) as! [String: Any] {
          print(decodedResp["success"] as! Bool)
          if decodedResp["success"] as! Bool {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let finishViewController = storyBoard.instantiateViewController(withIdentifier: "FinishViewController")
            self.present(finishViewController, animated: true, completion: nil)
          } else {
            let errorMsg = decodedResp["errorMsg"]
            if errorMsg == nil {
              return
            }
            self.handleError(errorMsg: errorMsg as! String)
          }
        }
      })
    } catch ATPError.net {
      VotingRenderer.removeSpinner(spinner: sv)
      self.handleError(errorMsg: ErrorMsg.net)
    } catch {
      VotingRenderer.removeSpinner(spinner: sv)
      self.handleError(errorMsg: ErrorMsg.other)
    }
  }

  open func vote(_ vote: Vote, completion: @escaping (String?) -> Void) throws {
    fatalError("Subclasses need to implement the method.")
  }

  open func getCampaignID() -> String {
    fatalError("Subclasses need to implement the method.")
  }

  public func dispose() {

  }

  override open func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    setupKit()
  }

  // MARK: - Lifecycle
  override open func viewDidLoad() {
    super.viewDidLoad()
    setupKit()

    func setUI() {
      let xPos: CGFloat = 112.5
      let yPos: CGFloat = 7
      let frame = CGRect(x: xPos, y: yPos, width: 310, height: 30)
      let tf = ValidationTextField(frame: frame)
      tf.addTarget(self, action: #selector(textFieldEditingDidChange(_:)), for: UIControlEvents.editingChanged)
      tf.addTarget(self, action: #selector(textFieldDidEndEditingAction(_:)), for: UIControlEvents.editingDidEnd)
      navigationItem.titleView = tf

      navigationController?.navigationBar.isTranslucent = false
    }

    setUI()
  }

  func unsetComponents() {
    if (toolbar.items?.count)! > 2 {
      (toolbar.items![1] as UIBarButtonItem).isEnabled = false
    }
  }

  func setComponents() {
    if allProjects.count == 0 {
      print("no project")
      return
    }

    let subviews: [UIView] = self.view.subviews

    if subviews.count > 4 {
      for index in 4..<subviews.count {
        let subview: UIView = subviews[index]
        subview.removeFromSuperview()
      }
    }

    if question != nil {
      _ = createLabel(frame: CGRect(x: self.view.frame.size.width / 2 - 131, y: 20, width: 262, height: 17), text: question!)
    }

    let frame = CGRect(x: self.view.frame.size.width / 2 - 131, y: 60, width: 262, height: 17)
    headButton = createRadioButton(frame: frame, title: allProjects[0], color: UIColor.blue)

    if allProjects.count < 2 {
      return
    }

    var otherButtons: [DLRadioButton] = []

    for index in 1..<allProjects.count {
      let project = allProjects[index]
      let frame = CGRect(x: self.view.frame.size.width / 2 - 131, y: 90 + 30 * CGFloat(index - 1), width: 262, height: 17)
      let radioButton = createRadioButton(frame: frame, title: project, color: UIColor.blue)
      otherButtons.append(radioButton)
    }

    headButton!.otherButtons = otherButtons

    loadPreviousState()

    let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let voteButton = UIBarButtonItem(title: "Vote", style: .plain, target: self, action: Selector.voteProject)
    let toolbarButtonItems = [space, voteButton, space]
    toolbar.setItems(toolbarButtonItems, animated: true)
    (toolbar.items![1] as UIBarButtonItem).isEnabled = (currentIndex != -1)
  }

  // MARK: - Memento Pattern
  @objc func saveCurrentState() {
    // When the user leaves the app and then comes back again, he wants it to be in the exact same state
    // he left it. In order to do this we need to save the currently displayed project.
    // Since it's only one piece of information we can use NSUserDefaults.
//    UserDefaults.standard.set(currentIndex, forKey: Constants.indexRestorationKey)
  }

  func loadPreviousState() {
//    currentIndex = UserDefaults.standard.integer(forKey: Constants.indexRestorationKey)
    if currentIndex == -1 {
      headButton?.isSelected = false
      headButton?.otherButtons.forEach { option in
        option.isSelected = false
      }
    } else if currentIndex == 0 {
      headButton?.isSelected = true
    } else {
      if let count = headButton?.otherButtons.count, count < currentIndex {
        headButton?.otherButtons[count - 1].isSelected = true
      } else {
        headButton?.otherButtons[currentIndex - 1].isSelected = true
      }
    }
  }

  @objc func voteProject() {
    let votedProject = allProjects[currentIndex]
    print("project", votedProject)
    emitEvent(atpEvent: String(currentIndex + 1))
  }

  // MARK: Helper

  private func createLabel(frame: CGRect, text: String) -> UILabel {
    let label = UILabel(frame: frame)
    label.text = text
    label.textAlignment = .left
    self.view.addSubview(label)

    return label
  }

  private func createRadioButton(frame: CGRect, title: String, color: UIColor) -> DLRadioButton {
    let radioButton = DLRadioButton(frame: frame)
    radioButton.titleLabel!.font = UIFont.systemFont(ofSize: 14)
    radioButton.setTitle(title, for: [])
    radioButton.setTitleColor(color, for: [])
    radioButton.iconColor = color
    radioButton.indicatorColor = color
    radioButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
    radioButton.addTarget(self, action: #selector(logSelectedButton), for: UIControlEvents.touchUpInside)
    radioButton.isMultipleSelectionEnabled = false
    radioButton.isMultipleTouchEnabled = false
    self.view.addSubview(radioButton)

    return radioButton
  }

  @IBAction private func logSelectedButton(radioButton: DLRadioButton) {
    let project: String = radioButton.selected()!.titleLabel!.text!
    print(String(format: "%@ is selected.\n", project))
    currentIndex = allProjects.index {
      $0 == project
    }!
    if currentIndex == 0 {
      headButton?.otherButtons.forEach {
        $0.isSelected = false
      }
    } else {
      headButton?.isSelected = false
      headButton?.otherButtons.forEach {
        $0.isSelected = false
      }
      radioButton.isSelected = true
    }
    (toolbar.items![1] as UIBarButtonItem).isEnabled = (currentIndex != -1)
  }

  private func textFieldAction() {
    let tf: ValidationTextField = navigationItem.titleView as! ValidationTextField
    let nasAddr: String = tf.text!
    print("textField: \(nasAddr)")
    let result = tf.validate(rule: ValidationRuleLength(min: 35, max: 35, error: ValidationError.invalidError(message: "Invalid Length")))
    if result.isValid {
      debugPrint("valid")
      tf.setValid(isValid: true)
      currentIndex = -1
      let sv = VotingRenderer.displaySpinner(onView: self.view)
      do {
        try register(nasAddress: nasAddr, completion: { tie in
          if tie != nil {
            if tie?.type == TIEType.error {
              VotingRenderer.removeSpinner(spinner: sv)
              self.handleError(errorMsg: (tie?.raw)!)
              return
            }
            guard let voteData: VoteData = try? self.parseTIE(tie: tie!) else {
              VotingRenderer.removeSpinner(spinner: sv)
              self.handleError(errorMsg: ErrorMsg.end)
              return
            }
            self.nasAddress = nasAddr
            self.allProjects = voteData.options
            self.question = voteData.question
            self.render()
            VotingRenderer.removeSpinner(spinner: sv)
          } else {
            self.unsetComponents()
            VotingRenderer.removeSpinner(spinner: sv)
          }
        })
      } catch ATPError.net {
        VotingRenderer.removeSpinner(spinner: sv)
        handleError(errorMsg: ErrorMsg.net)
      } catch ATPError.duplicate {
        VotingRenderer.removeSpinner(spinner: sv)
        handleError(errorMsg: ErrorMsg.end)
      } catch {
        VotingRenderer.removeSpinner(spinner: sv)
        handleError(errorMsg: ErrorMsg.other)
      }
    } else {
      debugPrint("invalid")
      tf.setValid(isValid: false)
    }
  }

  open func register(nasAddress: String, completion: @escaping (TIE?) -> Void) throws {
    fatalError("Subclasses need to implement the method.")
  }

  open func parseTIE(tie: TIE) throws -> VoteData {
    fatalError("Subclasses need to implement the method.")
  }

  open func setupKit() {
    fatalError("Subclasses need to implement the method.")
  }

  @IBAction private func textFieldEditingDidChange(_ sender: Any) {
    textFieldAction()
  }

  @IBAction private func textFieldDidEndEditingAction(_ sender: Any) {
    textFieldAction()
  }

  private func handleError(errorMsg: String) {
    let alert = UIAlertController(title: "", message: errorMsg
        , preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
      switch action.style {
      case .default:
        print("default")

      case .cancel:
        print("cancel")

      case .destructive:
        print("destructive")

      }
    }))
    self.present(alert, animated: true, completion: nil)
  }

}

extension VotingRenderer {
  class func displaySpinner(onView: UIView) -> UIView {
    let spinnerView = UIView.init(frame: onView.bounds)
    spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
    let ai = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
    ai.startAnimating()
    ai.center = spinnerView.center

    DispatchQueue.main.async {
      spinnerView.addSubview(ai)
      onView.addSubview(spinnerView)
    }

    return spinnerView
  }

  class func removeSpinner(spinner: UIView) {
    DispatchQueue.main.async {
      spinner.removeFromSuperview()
    }
  }
}

fileprivate extension Selector {
  static let voteProject = #selector(VotingRenderer.voteProject)
  static let saveCurrentState = #selector(VotingRenderer.saveCurrentState)
}

enum ValidationError: Error {
  case invalidError(message: String)
}
