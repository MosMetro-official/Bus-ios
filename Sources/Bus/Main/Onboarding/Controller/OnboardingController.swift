//
//  OnboardingController.swift
//  MosmetroNew
//
//  Created by Гусейн on 21.12.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import Foundation
import UIKit

class OnboardingController: BaseController {
    
    let onboardingView = OnboardingView.loadFromNib()
    
    @objc var onboardingName = "" {
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
        self.onboardingView.viewState = .loading
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
}

extension OnboardingController {
    private func load() {
        self.onboardingView.viewState = .loading
        OnboardingModel.loadOnboarding(name: onboardingName, callback: { result in
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
    
    private func setup() {
        
    }
    
    private func makeState() {
        DispatchQueue.global(qos: .userInitiated).async {
            let items: [Element] = self.model.map { boarding in
                let image = Element(content:
                                        OnboardingView.ViewState.Image(imageURL: boarding.imageURL ?? "")
                )
                
                let subtitle = boarding.subtitle.toAttributed(color: .textPrimary, font: .Body_17_Regular)
                let text = Element(content:
                                    OnboardingView.ViewState.Text(title: boarding.title, mainText: subtitle)
                )
                let tableState = OldState(model: SectionState(header: nil, footer: nil), elements: [image,text])
                return Element(content: OnboardingView.ViewState.ContentCell(items: tableState))
            }
            
            let collectionState = OldState(model: SectionState(header: nil, footer: nil), elements: items)
            
            let state = OnboardingView.ViewState.Loaded(collectionState: collectionState, onContinue: self.onClose)
            DispatchQueue.main.async {
                self.onboardingView.viewState = .loaded(state)
            }
           
        }
        
    }
  
}
