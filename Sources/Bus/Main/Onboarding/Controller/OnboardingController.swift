//
//  OnboardingController.swift
//  MosmetroNew
//
//  Created by Гусейн on 21.12.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import UIKit

class OnboardingController : BaseController {
    
    let onboardingView = B_OnboardingView.loadFromNib()
    
    @objc
    var onboardingName = "" {
        didSet {
            load()
        }
    }
    
    var onClose: (() -> Void)?
    
    var model: [OnboardingModel] = [] {
        didSet {
            makeState()
        }
    }
    
    override func loadView() {
        super.loadView()
        self.view = onboardingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
        self.onboardingView.viewState = .loading
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
}

extension OnboardingController {
    
    private func load() {
        self.onboardingView.viewState = .loading
        OnboardingModel.loadOnboarding(name: "onboarding_ios_buses", callback: { result in
            switch result {
            case .success(let boardings):
                self.model = boardings
            case .failure(let err):
                self.onboardingView.viewState = .error(.init(style: .warning, title: err.errorDescription, onRetry: nil))
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        })
    }
    
    private func makeState() {
        DispatchQueue.global(qos: .userInitiated).async {
            let items: [Element] = self.model.map { boarding in
                let image = Element(
                    content: B_OnboardingView.ViewState.Image(
                        imageURL: boarding.imageURL ?? ""
                    )
                )
                
                let subtitle = boarding.subtitle.toAttributed(color: .textPrimary, font: .Body_17_Regular)
                let text = Element(
                    content: B_OnboardingView.ViewState.Text(
                        title: boarding.title,
                        mainText: subtitle
                    )
                )
                let tableState = OldState(model: SectionState(header: nil, footer: nil), elements: [image,text])
                return Element(
                    content: B_OnboardingView.ViewState.ContentCell(
                        items: tableState
                    )
                )
            }
            
            let collectionState = OldState(
                model: SectionState(
                    header: nil,
                    footer: nil
                ),
                elements: items
            )
            
            let state = B_OnboardingView.ViewState.Loaded(collectionState: collectionState, onContinue: self.onClose)
            DispatchQueue.main.async {
                self.onboardingView.viewState = .loaded(state)
            }
        }
    }
}
