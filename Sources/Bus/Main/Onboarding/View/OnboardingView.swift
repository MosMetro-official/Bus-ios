//
//  OnboardingView.swift
//  MosmetroNew
//
//  Created by Гусейн on 21.12.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import UIKit

// https://images.unsplash.com/photo-1520106212299-d99c443e4568?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1974&q=80
class OnboardingView : UIView {
    
    enum ViewState {
        case loading
        case loaded(Loaded)
        case error(MetroAlertView.ViewState)
        
        struct Loaded {
            let collectionState : OldState
            let onContinue : (() -> ())?
        }
        
        struct ContentCell: _OnboardingCollectionCell {
            var items : OldState
        }
        
        struct Image: _OnboardinImageCell {
            var imageURL : String
        }
        
        struct Text: _OnboardingTextTableCell {
            var title : String
            var mainText : NSAttributedString
        }
    }
    
    var viewState: ViewState = .loading {
        didSet {
            render()
        }
    }
    
    @IBOutlet var continueButton: UIButton!
    
    @IBOutlet var collectionView: BaseCollectionView!
    
    @IBOutlet var pageControl: UIPageControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    @IBAction func handleContinue(_ sender: Any) {
        if case .loaded(let loadedState) = self.viewState {
            loadedState.onContinue?()
        }
    }
}

extension OnboardingView {
    
    private func render() {
        DispatchQueue.main.async {
            switch self.viewState {
            case .loading:
                self.showLoading(with: .initial)
            case .loaded(let state):
                self.removeLoading { [weak self] in
                    self?.pageControl.numberOfPages = state.collectionState.elements.count
                    self?.collectionView.viewStateInput = [state.collectionState]
                    self?.pageControl.alpha = 1
                }
            case .error(let err):
                self.removeLoading { [weak self] in
                    self?.showMetroAlert(with: err)
                }
            }
        }
    }
    
    private func handleAnimations(isShowing: Bool) {
        UIView.animate(withDuration: 0.15, delay: 0, options: [.curveEaseInOut], animations: {
            self.continueButton.alpha = isShowing ? 1 : 0
            self.pageControl.alpha = isShowing ? 0 : 1
        }, completion: nil)
    }
    
    private func setup() {
        continueButton.roundCorners(.all, radius: 8)
        pageControl.roundCorners(.all, radius: 13)
        collectionView.shouldInterrupt = true
        collectionView.onPageChange = { [weak self] page in
            self?.pageControl.currentPage = page
            if case .loaded(let loadedState) = self?.viewState {
                if loadedState.onContinue != nil {
                    self?.handleAnimations(isShowing: page == (loadedState.collectionState.elements.endIndex - 1))
                }
            }
        }
        collectionView.onScroll = { [weak self] scrollView in
            guard let self = self else { return }
            for cell: OnboardingCollectionCell in self.collectionView.visibleCells as! [OnboardingCollectionCell] {
                cell.parallaxTheImageViewScrollOffset(offsetPoint: self.collectionView.contentOffset)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            if let flowLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: self.collectionView.frame.size.height)
                flowLayout.minimumLineSpacing = 0
                flowLayout.minimumInteritemSpacing = 0
                flowLayout.sectionInset = .zero
            }
        })
    }
}
