//
//  B_MetroLoadingView.swift
//  MosmetroNew
//
//  Created by Сеня Римиханов on 28.10.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import UIKit

class B_MetroLoadingView : UIView {
    
    @IBOutlet private weak var blurView: UIVisualEffectView!
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var loadingLabel: UILabel!
    
    struct ViewState {
        var title: String? = "Loading...".localized(in: Bus.shared.bundle)
        let subtitle: String?
        var isUsingBlur: Bool = false
        
        static let initial = ViewState(title: "Loading...".localized(in: Bus.shared.bundle), subtitle: nil, isUsingBlur: false)
    }
    
    private var viewState: ViewState = .initial {
        didSet {
            render()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
}

extension B_MetroLoadingView {
    private func setup() {
        if #available(iOS 13.0, *) {
            let effect = UIBlurEffect(style: .systemThinMaterial)
            self.blurView.effect = effect
        }
        
    }
    
    private func render() {
        var effect = UIBlurEffect(style: .regular)
        if #available(iOS 13.0, *) {
            effect = UIBlurEffect(style: .systemThinMaterial)
        }
        self.blurView.effect = viewState.isUsingBlur ? effect : nil
        self.loadingLabel.text = viewState.title
        
        self.subtitleLabel.isHidden = viewState.subtitle == nil ? true : false
        self.subtitleLabel.text = viewState.subtitle
    }
    
    public func configure(with state: ViewState) {
        self.viewState = state
    }
}

extension UIView {
    @discardableResult
    func showLoading(with state: B_MetroLoadingView.ViewState = B_MetroLoadingView.ViewState(title: "Loading...".localized(in: Bus.shared.bundle), subtitle: nil, isUsingBlur: false)) -> B_MetroLoadingView {
        let loadingView = B_MetroLoadingView.loadFromNib()
        loadingView.tag = 753
        self.addSubview(loadingView)
        loadingView.pin(on: self) {[
            $0.topAnchor   .constraint(equalTo: $1.topAnchor),
            $0.leftAnchor     .constraint(equalTo: $1.leftAnchor),
            $0.rightAnchor    .constraint(equalTo: $1.rightAnchor),
            $0.bottomAnchor   .constraint(equalTo: $1.bottomAnchor)
        ]}
        loadingView.configure(with: state)
        return loadingView
    }
    
    func removeLoading(completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            self.subviews.forEach { subview in
                if subview.tag == 753 {
                    UIView.animate(withDuration: 0.3, delay: 0, animations: {
                        subview.alpha = 0
                    }, completion: { finished in
                        if finished {
                            completion?()
                            subview.removeFromSuperview()
                        }
                    })
                }
            }
        }
    }
    
    @discardableResult
    func showLoading(above subview: UIView, with state: B_MetroLoadingView.ViewState = B_MetroLoadingView.ViewState(title: nil, subtitle: nil, isUsingBlur: false)) -> B_MetroLoadingView {
        let loadingView = B_MetroLoadingView.loadFromNib()
        loadingView.tag = 753
        self.insertSubview(loadingView, aboveSubview: subview)
        loadingView.pin(on: self) {[
            $0.topAnchor   .constraint(equalTo: $1.topAnchor),
            $0.leftAnchor     .constraint(equalTo: $1.leftAnchor),
            $0.rightAnchor    .constraint(equalTo: $1.rightAnchor),
            $0.bottomAnchor   .constraint(equalTo: $1.bottomAnchor)
        ]}
        loadingView.configure(with: state)
        
        return loadingView
    }
    
    func showLoadingController(with transitionDelegate: LKFadeTransition, state: B_MetroLoadingView.ViewState) {
        DispatchQueue.main.async { [weak self] in
            let controller = MetroLoadingController()
            controller.transitioningDelegate = transitionDelegate
            controller.modalPresentationStyle = .custom
            controller.modalPresentationCapturesStatusBarAppearance = true
            controller.loadingView.configure(with: state)
            self?.parentViewController?.navigationController?.present(controller, animated: true, completion: nil)
        }
    }
    
    func removeLoadingController(completion: (() -> Void)?) {
        DispatchQueue.main.async { [weak self] in
            if let _ = self?.parentViewController?.navigationController?.presentedViewController as? MetroLoadingController {
                self?.parentViewController?.navigationController?.presentedViewController?.dismiss(animated: true, completion: {
                    completion?()
                })
            }
        }
    }
}
