//
//  BaseController.swift
//  MosmetroNew
//
//  Created by Сеня Римиханов on 04.05.2020.
//  Copyright © 2020 Гусейн Римиханов. All rights reserved.
//

import UIKit
import StoreKit
import MessageUI
import FloatingPanel
import SafariServices
import Localize_Swift

let delay = 0.01

let animationDuration = 0.3

class BaseController : UIViewController {
    
    var onLanguageChange: (() -> ())?
    
    lazy var visualEffectView: UIVisualEffectView? = {
        let blurEffect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        self.view.backgroundColor = UIColor.baseIOS
        let backBarButtton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButtton
    }
    
    @objc
    func setText() {
        onLanguageChange?()
    }
    
    func setTransparentNavBar() {
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    @discardableResult
    public func openWeb(link: String) -> SFSafariViewController? {
        if let sc = BaseController.safariController(link) {
            present(sc, animated: true, completion: nil)
            return sc
        }
        return nil
    }
    
    class func safariController(_ link: String) -> SFSafariViewController? {
        guard let url = URL(string: link) else { return nil }
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredBarTintColor = .baseIOS
        safariVC.preferredControlTintColor = .main
        return safariVC
    }
    
    public func openMailController(_ message: MailMessage) {
//        if MFMailComposeViewController.canSendMail() {
//            let mailController = LKPTechSupport.mailCompose(nil)
//            mailController.mailComposeDelegate = self
//            mailController.setToRecipients([message.to])
//            mailController.setSubject(message.title)
//            mailController.setMessageBody(message.body, isHTML: false)
//            present(mailController, animated: true)
//
//            // Show third party email composer if default Mail app is not present
//        } else if let emailUrl = createEmailUrl(to: message.to, subject: message.title, body: message.body) {
//            UIApplication.shared.open(emailUrl)
//        }
    }
}

extension BaseController : MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
