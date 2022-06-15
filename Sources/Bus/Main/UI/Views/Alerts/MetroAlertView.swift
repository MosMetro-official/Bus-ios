//
//  MetroAlertView.swift
//  MosmetroNew
//
//  Created by Гусейн on 20.10.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import UIKit
import ViewAnimator

class MetroAlertView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "MoscowSans-Medium", size: 14)
        label.textColor = .textPrimary
        label.numberOfLines = 0
        return label
    }()
    
    private let leftImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .textPrimary
        let image = UIImage(named: "alert_retry", in: .module, with: nil)
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let backView: BlurView = {
        let blurView = BlurView(frame: CGRect(x: 12, y: 10, width: UIScreen.main.bounds.width - 24, height: 44), cornerRadius: 10)
        return blurView
    }()
    
    @objc private func handleRetry(_ sender: UIButton) {
        viewState.onRetry?()
    }
    
    struct ViewState {
        // Style of alert.
        // Use cases:
        // – .info for non-critical actions
        // - .warning for critical errors (network code 500)
        // - .success for posotivie actions
        enum Style {
            case info, warning, success
        }
        
        let style: Style
        // text for view
        let title: String
        // action on button. Can be optional if there is no action
        let onRetry: (() -> ())?
        
        static let initial = ViewState(style: .info, title: "Some", onRetry: nil)
        
    }
    
    var viewState: ViewState = .initial {
        didSet {
            render()
        }
    }
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
}

// Staric methods
extension MetroAlertView {
    
    @discardableResult
    ///  Shows alert view like snackbar obn bottom
    /// - Parameters:
    ///   - state: State for view – what to render in alert
    ///   - isHiding: Tells view if its need to hide after some time. Default true
    ///   - removeAfter: Tells when to dissmiss view from superview. Default = 2 seconds
    /// - Returns: view itself
    static func showMetroAlert(with state: MetroAlertView.ViewState, isHiding: Bool = true, removeAfter: Double = 2.0) -> MetroAlertView {
        let alertView = MetroAlertView(frame: .zero)
        alertView.tag = 357
        guard let window = UIApplication.shared.keyWindow else { return alertView }
        window.addSubview(alertView)
        alertView.pin(on: window) {[
            $0.leftAnchor     .constraint(equalTo: $1.safeAreaLayoutGuide.leftAnchor),
            $0.rightAnchor    .constraint(equalTo: $1.safeAreaLayoutGuide.rightAnchor),
            $0.bottomAnchor   .constraint(equalTo: $1.safeAreaLayoutGuide.bottomAnchor,constant: -$1.safeAreaInsets.bottom)
        ]}
        let fromAnimation = AnimationType.from(direction: .bottom, offset: 100)
        UIView.animate(views: [alertView],
                       animations: [fromAnimation],
                       initialAlpha: 0,
                       finalAlpha: 1,
                       duration: 0.5)
        alertView.viewState = state
        if isHiding {
            DispatchQueue.main.asyncAfter(deadline: .now() + removeAfter, execute: {
                Self.removeMetroAlert()
            })
        }
        return alertView
    }
    
    /// Removes alert view from superview (animated)
    static func removeMetroAlert() {
        guard let window = UIApplication.shared.keyWindow else { return }
        window.subviews.forEach { subview in
            if subview.tag == 357 {
                let fromAnimation = AnimationType.from(direction: .bottom, offset: 0)
                UIView.animate(views: [subview],
                               animations: [fromAnimation],
                               initialAlpha: 1,
                               finalAlpha: 0,
                               duration: 0.5,
                               completion: { subview.removeFromSuperview() })
            }
        }
    }
}

extension MetroAlertView {
    
    private func setup() {
        self.addSubview(backView)
        backView.pin(on: self) {[
            $0.leftAnchor.constraint(equalTo: $1.leftAnchor, constant: 12),
            $0.rightAnchor.constraint(equalTo: $1.rightAnchor, constant: -12),
            $0.bottomAnchor.constraint(equalTo: $1.bottomAnchor, constant: -26),
            $0.topAnchor.constraint(equalTo: $1.topAnchor, constant: 12)
        ]}
        
        backView.contentView.addSubview(leftImageView)
        leftImageView.pin(on: backView.contentView) {[
            $0.leftAnchor.constraint(equalTo: $1.leftAnchor, constant: 12),
            $0.centerYAnchor.constraint(equalTo: $1.centerYAnchor),
            $0.widthAnchor.constraint(equalToConstant: 24),
            $0.heightAnchor.constraint(equalToConstant: 24),
        ]}
        
        backView.contentView.addSubview(retryButton)
        retryButton.addTarget(self, action: #selector(handleRetry(_:)), for: .touchUpInside)
        retryButton.pin(on: backView.contentView) {[
            $0.rightAnchor.constraint(equalTo: $1.rightAnchor, constant: -12),
            $0.centerYAnchor.constraint(equalTo: $1.centerYAnchor),
            $0.widthAnchor.constraint(equalToConstant: 24),
            $0.heightAnchor.constraint(equalToConstant: 24)
        ]}
        
        backView.contentView.addSubview(titleLabel)
        titleLabel.pin(on: backView.contentView) {[
            $0.leftAnchor.constraint(equalTo: leftImageView.rightAnchor, constant: 6),
            $0.topAnchor.constraint(equalTo: $1.topAnchor, constant: 9),
            $0.rightAnchor.constraint(equalTo: retryButton.leftAnchor, constant: 8),
            $0.bottomAnchor.constraint(equalTo: $1.bottomAnchor, constant: -9)
        ]}
        
    }
    
    private func render() {
        self.titleLabel.text = viewState.title
        switch viewState.style {
        case .info:
            self.backView.visualEffectView.layer.borderWidth = 0
            self.backView.visualEffectView.layer.borderColor = UIColor.clear.cgColor
            self.leftImageView.tintColor = .textPrimary
            self.leftImageView.image = UIImage.getAssetImage(name: "emergency_circle")
            self.retryButton.isHidden = true
        case .warning:
            self.backView.visualEffectView.layer.borderWidth = 1
            self.backView.visualEffectView.layer.borderColor = UIColor.metroRed.cgColor
            self.retryButton.isHidden = viewState.onRetry == nil ? true : false
            self.leftImageView.tintColor = .metroRed
            self.leftImageView.image = UIImage(named: "Warning", in: .module, with: nil)
        case .success:
            self.backView.visualEffectView.layer.borderWidth = 1
            self.backView.visualEffectView.layer.borderColor = UIColor.metroGreen.cgColor
            self.retryButton.isHidden = true
            self.leftImageView.tintColor = .metroGreen
            self.leftImageView.image = UIImage.getAssetImage(name: "checkmark_template")
        }
    }
}

extension UIView {
    
    @discardableResult
    ///  Shows alert view like snackbar obn bottom
    /// - Parameters:
    ///   - state: State for view – what to render in alert
    ///   - isHiding: Tells view if its need to hide after some time. Default true
    ///   - removeAfter: Tells when to dissmiss view from superview. Default = 2 seconds
    /// - Returns: view itself
    func showMetroAlert(with state: MetroAlertView.ViewState, isHiding: Bool = true, removeAfter: Double = 2.0) -> MetroAlertView {
        let alertView = MetroAlertView(frame: .zero)
        alertView.tag = 357
        self.addSubview(alertView)
        alertView.pin(on: self) {[
            $0.leftAnchor     .constraint(equalTo: $1.safeAreaLayoutGuide.leftAnchor),
            $0.rightAnchor    .constraint(equalTo: $1.safeAreaLayoutGuide.rightAnchor),
            $0.bottomAnchor   .constraint(equalTo: $1.safeAreaLayoutGuide.bottomAnchor)
        ]}
        let fromAnimation = AnimationType.from(direction: .bottom, offset: 100)
        UIView.animate(views: [alertView],
                       animations: [fromAnimation],
                       initialAlpha: 0,
                       finalAlpha: 1,
                       duration: 0.5)
        alertView.viewState = state
        if isHiding {
            DispatchQueue.main.asyncAfter(deadline: .now() + removeAfter, execute: { [weak self] in
                self?.removeMetroAlert()
            })
        }
        
        return alertView
    }
    
    /// Removes alert view from superview (animated)
    func removeMetroAlert() {
        self.subviews.forEach { subview in
            if subview.tag == 357 {
                let fromAnimation = AnimationType.from(direction: .bottom, offset: 0)
                UIView.animate(views: [subview],
                               animations: [fromAnimation],
                               initialAlpha: 1,
                               finalAlpha: 0,
                               duration: 0.5,
                               completion: { subview.removeFromSuperview() })
            }
        }
    }
}

extension UIViewController {
    
    @discardableResult
    ///  Shows alert view like snackbar obn bottom
    /// - Parameters:
    ///   - state: State for view – what to render in alert
    ///   - isHiding: Tells view if its need to hide after some time. Default true
    ///   - removeAfter: Tells when to dissmiss view from superview. Default = 2 seconds
    /// - Returns: view itself
    func showMetroAlert(with state: MetroAlertView.ViewState, isHiding: Bool = true, removeAfter: Double = 2.0) -> MetroAlertView {
            let alertView = MetroAlertView(frame: .zero)
            alertView.tag = 357
            self.view.addSubview(alertView)
            alertView.pin(on: self.view) {[
                $0.leftAnchor     .constraint(equalTo: $1.safeAreaLayoutGuide.leftAnchor),
                $0.rightAnchor    .constraint(equalTo: $1.safeAreaLayoutGuide.rightAnchor),
                $0.bottomAnchor   .constraint(equalTo: $1.safeAreaLayoutGuide.bottomAnchor)
            ]}
            let fromAnimation = AnimationType.from(direction: .bottom, offset: 100)
            UIView.animate(views: [alertView],
                           animations: [fromAnimation],
                           initialAlpha: 0,
                           finalAlpha: 1,
                           duration: 0.5)
            alertView.viewState = state
            if isHiding {
                DispatchQueue.main.asyncAfter(deadline: .now() + removeAfter, execute: { [weak self] in
                    self?.removeMetroAlert()
                })
            }
            return alertView
    }
    
    /// Removes alert view from superview (animated)
    func removeMetroAlert() {
        self.view.subviews.forEach { subview in
            if subview.tag == 357 {
                let fromAnimation = AnimationType.from(direction: .bottom, offset: 0)
                UIView.animate(views: [subview],
                               animations: [fromAnimation],
                               initialAlpha: 1,
                               finalAlpha: 0,
                               duration: 0.5,
                               completion: { subview.removeFromSuperview() })
            }
        }
    }
}
