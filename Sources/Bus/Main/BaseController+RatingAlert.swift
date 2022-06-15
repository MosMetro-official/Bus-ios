//
//  BaseController+RatingAlert.swift
//  MosmetroNew
//
//  Created by Павел Кузин on 24.11.2020.
//  Copyright © 2020 Гусейн Римиханов. All rights reserved.
//

import UIKit
import FloatingPanel

//MARK: - Floating Panel For Rating
extension BaseController : FloatingPanelControllerDelegate {
    
    private func showRagePanel(vc: UIViewController) {
        self.view.endEditing(true)
        floatingPanelController          = BasePanelController(contentVC: vc, positions: .modal, state: .full)
        floatingPanelController.delegate = self
        switch vc {
        case is RagePanelVC :
            rageController = vc as? RagePanelVC

            rageController.onClose = { [weak self] in
                guard let self = self else { return }
                self.floatingPanelController = nil
                self.rageController = nil
            }
//        case is ChangeIconController :
//            changeIconController = vc as? ChangeIconController
//
//            changeIconController.onClose = { [weak self] in
//                guard let self = self else { return }
//                self.rageControllerFPC.removePanelFromParent(animated: true)
//                self.rageControllerFPC = nil
//                self.rageController = nil
//            }
        default:
            break
        }
        
        Utils.root()?.present(floatingPanelController, animated: true)
    }
}

//MARK: - Rating alert
extension BaseController {
    
    public func showRatingAlert() {
        setupVisualEffectView()
        setAlert()
        animateIn()
    }
    
    public func dismissRatingAlert() {
        animateOut()
    }
    
    //MARK:
    open func handlingCurrentLaunch() {
//        switch currentLaunch {
//        case 5, 50, 20:
//            let seconds = 3.0
//            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
//                self.showRatingAlert()
//                currentLaunch += 1
//            }
//        default:
//            print("############################")
//            print("Current launch is \(currentLaunch)")
//            print("############################")
//        }
    }
    
    //MARK: BLUR
    private func setupVisualEffectView() {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        window.addSubview(visualEffectView ?? UIVisualEffectView())
        visualEffectView?.pin(on: window) {[
            $0.topAnchor.constraint(equalTo: $1.topAnchor),
            $0.leadingAnchor.constraint(equalTo: $1.leadingAnchor),
            $0.trailingAnchor.constraint(equalTo: $1.trailingAnchor),
            $0.bottomAnchor.constraint(equalTo: $1.bottomAnchor),
        ]}
        visualEffectView?.alpha = 0
    }
    //MARK: ALERT
    private func setAlert() {
        alertView  = AlertView.loadFromNib()
        let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
        window?.addSubview(alertView ?? UIView())
        alertView?.center = CGPoint(x: view.frame.size.width  / 2,
                                    y: view.frame.size.height / 2)

        let tap = UITapGestureRecognizer(target: self, action: #selector(blurTaped))
        tap.numberOfTapsRequired = 1
        visualEffectView?.addGestureRecognizer(tap)
        
        //CLOSING
        alertView?.onClose = { [weak self] in
            self?.animateOut()
        }
        //OPEN APPStore
        alertView?.openStoreReview = { [weak self] in
            guard self != nil else { return }
            self?.animateOut()
            self?.openAppStoreReview()
        }
        //OPEN RAGE PANEL
        alertView?.openRagePanel = { [weak self] in
            guard self != nil else { return }
            self?.animateOut()
            self?.rageController = RagePanelVC()
            self?.showRagePanel(vc: RagePanelVC())
        }
    }
    
    //
    private func openAppStoreReview(){
        if let url = URL(string: "https://apps.apple.com/app/id1093391186?action=write-review"),
           UIApplication.shared.canOpenURL(url)
        {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    //MARK: - Animations
    @objc
    private func blurTaped() {
        self.animateOut()
    }
    
    private func animateIn() {
        alertView?.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        alertView?.alpha = 0
        
        UIView.animate(withDuration: 0.2) {
            self.visualEffectView?.alpha = 1
            self.alertView?.alpha = 1
            self.alertView?.transform = CGAffineTransform.identity
        }
    }
    
    private func animateOut() {
        UIView.animate(withDuration: 0.2,
                       animations: {
                        self.visualEffectView?.alpha = 0
                        self.alertView?.alpha = 0
                        self.alertView?.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        }) { (_) in
            self.alertView?.removeFromSuperview()
            self.alertView = nil
        }
    }
}
