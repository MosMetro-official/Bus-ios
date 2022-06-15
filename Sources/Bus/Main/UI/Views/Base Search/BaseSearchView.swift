//
//  BaseSearchView.swift
//  MosmetroNew
//
//  Created by Сеня Римиханов on 11.11.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import UIKit
import RealmSwift

class BaseTextField: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}

class BaseSearchView: UIView {
    
    struct ViewState {
        var sectionsState: [OldState]
        var onTextChange: (String) -> ()
        var placeholder: String?
        
        static let initital = ViewState(sectionsState: [], onTextChange: { _ in  })
    }
    
    public var viewState: ViewState = .initital {
        didSet {
            render()
        }
    }
    
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var textFieldToSuperviewBottom: NSLayoutConstraint!
    @IBOutlet public weak var tableView: OldBaseTableView!
    @IBOutlet public weak var searchTextField: BaseTextField!
    @IBOutlet  weak var searchBarEffectView: UIVisualEffectView!
    
    private var isKeyboardWasHided = false
    private var bottomSafeArea: CGFloat = 0
    public var onDismiss: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    @IBAction func handleClose(_ sender: UIButton) {
        self.onDismiss?()
    }
}

extension BaseSearchView {
    
    @objc private func render() {
        self.searchTextField.placeholder = self.viewState.placeholder
        self.tableView.viewStateInput = self.viewState.sectionsState
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        self.viewState.onTextChange(text)
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        
        guard let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let endFrameY = endFrame.origin.y
        let endFrameHeight = endFrame.height
        let duration: TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        let animationCurve: UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
        
        if endFrameY >= UIScreen.main.bounds.size.height {
            self.textFieldToSuperviewBottom.constant = self.bottomSafeArea + 24
            self.tableView.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: self.bottomSafeArea + 44, right: 0)
        } else {
            self.tableView.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: endFrameHeight + 44, right: 0)
            self.textFieldToSuperviewBottom.constant = endFrameHeight + 8
            tableView.setContentOffset(tableView.contentOffset, animated:false)
            isKeyboardWasHided = false
        }
        print("END FRAME - \(endFrame), endFrameY - \(endFrameY)")
        UIView.animate(
            withDuration: duration,
            delay: TimeInterval(0),
            options: animationCurve,
            animations: { self.layoutIfNeeded() },
            completion: nil)
    }
    
    private func setup() {
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        NotificationCenter.default.addObserver(self,
               selector: #selector(self.keyboardNotification(notification:)),
               name: UIResponder.keyboardWillChangeFrameNotification,
               object: nil)
        searchTextField.roundCorners(.all, radius: 12)
        searchBarEffectView.roundCorners(.top, radius: 10)
        searchTextField.tintColor = .textPrimary
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.bottomSafeArea = self.safeAreaInsets.bottom
            self.textFieldToSuperviewBottom.constant = self.bottomSafeArea + 24
            self.layoutIfNeeded()
            self.searchTextField.becomeFirstResponder()
            
        })
   
        tableView.onScroll = { [weak self] scrollView in
            guard let self = self else { return }
            if scrollView.contentOffset.y > 5 {
                // scrolling down
                if !self.isKeyboardWasHided {
                    self.searchTextField.resignFirstResponder()
                    self.isKeyboardWasHided = true
                }

            } else if scrollView.contentOffset.y < -150 {
                self.onDismiss?()
            }
        }
    }
}
