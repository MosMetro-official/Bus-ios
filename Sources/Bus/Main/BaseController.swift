//
//  BaseController.swift
//  MosmetroNew
//
//  Created by Сеня Римиханов on 04.05.2020.
//  Copyright © 2020 Гусейн Римиханов. All rights reserved.
//

import Foundation
import UIKit
import SafariServices
import MessageUI
import Localize_Swift
import FloatingPanel
import StoreKit

//FOR TableView Animation
let animationDuration = 0.3
let delay = 0.01

class BaseController: UIViewController {
    
    var alertView               : AlertView?
    var rageController          : RagePanelVC!
    var floatingPanelController : FloatingPanelController!
    
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
        self.view.backgroundColor = UIColor.MKBase
        let backBarButtton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButtton
        handlingCurrentLaunch()
    }
    
    @objc
    func setText() {
        onLanguageChange?()
    }
}

extension BaseController {
    public func openDeeplink() {
        if let url = URL(string: "mosmetrohologram") {
            UIApplication.shared.open(url, options: .init())
        }
    }
    
    func setTransparentNavBar() {
           self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
           self.navigationController?.navigationBar.shadowImage   = UIImage()
           self.navigationController?.navigationBar.isTranslucent = true
           self.navigationController?.view.backgroundColor        = .clear
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
        safariVC.preferredBarTintColor = .MKBase
        safariVC.preferredControlTintColor = .mainColor
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

extension BaseController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
           controller.dismiss(animated: true)
    }
}
