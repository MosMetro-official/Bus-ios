//
//  RagePanelVC.swift
//  MosmetroNew
//
//  Created by Павел Кузин on 23.11.2020.
//  Copyright © 2020 Гусейн Римиханов. All rights reserved.
//

import UIKit

class RagePanelVC: UIViewController {
    
    var onClose : (() -> ())?

    @IBOutlet weak var bgBlurView  : UIVisualEffectView!
    @IBOutlet weak var upperLabel  : UILabel!
    @IBOutlet weak var closeButton : UIButton!
    @IBOutlet weak var textView    : UITextView!
    @IBOutlet weak var sendButton  : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        upperLabel.text = "0/400"
        if #available(iOS 13.0, *) {
            let effect = UIBlurEffect(style: .systemMaterial)
            self.bgBlurView.effect = effect
            self.view              = bgBlurView
        }
        textView.becomeFirstResponder()
        textView.delegate          = self
        textView.textColor         = UIColor.textSecondary
        textView.text              = "RageTextView".localized(in: .module)
        textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument,
                                                        to  : textView.beginningOfDocument)
        sendButton.setTitle("Send".localized(in: .module), for: .normal)
    }
    
    @IBAction func handleSend(_ sender: Any) {
        
        let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        let buildString = "\(appVersion ?? "") (\(build ?? ""))"
        
//        AnalyticsService.reportEvent(with: "newmetro.feedback", parameters: [
//            "os"     : "iOS",
//            "os_ver" : "\(UIDevice.current.systemVersion)",
//            "app_ver": "\(buildString)",
//            "model"  : "iPhone",
//            "body"   : "\(textView.text ?? "Error in getting message")"
//        ])
        self.dismiss(animated: true, completion: nil)
        self.onClose?()
    }
    
    @IBAction func handleClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        self.onClose?()
    }
}

extension RagePanelVC : UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count >= 0 && textView.text.count <= 400 {
            sendButton.isEnabled = true
            sendButton.isHighlighted = false
            upperLabel.textColor = .textSecondary
        } else {
            sendButton.isEnabled = false
            sendButton.isHighlighted = true
            upperLabel.textColor = .main
        }
        textView.text != nil ? (upperLabel.text = ("\(textView.text.count)/400")) : (upperLabel.text = "0/400")
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == UIColor.textSecondary {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        if updatedText.isEmpty {
            textView.text = "RageTextView".localized(in: .module)
            textView.textColor = UIColor.textSecondary
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }
         else if textView.textColor == UIColor.textSecondary && !text.isEmpty {
            textView.textColor = UIColor.textPrimary
            textView.text = text
        }
        else {
            return true
        }
        return false
    }
}
