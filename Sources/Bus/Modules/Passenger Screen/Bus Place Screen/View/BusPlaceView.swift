//
//  BusPlaceView.swift
//  MosmetroNew
//
//  Created by Гусейн on 03.12.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import UIKit

class BusPlaceView: UIView {
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!
    @IBOutlet private var collectionView: BaseCollectionView!
    
    struct ViewState {
        let title: String
        let subtitle: String
        let collectionState: [OldState]
        
        struct Seat: _BusPlaceCollectionCell {
            var text: String
            var isSelected: Bool
            var isUnvailable: Bool
            var onSelect: () -> ()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    var viewState: ViewState = .init(title: "", subtitle: "", collectionState: []) {
        didSet {
            self.titleLabel.text = viewState.title
            self.subtitleLabel.text = viewState.subtitle
            self.collectionView.viewStateInput = viewState.collectionState
        }
    }
}

extension BusPlaceView {
    private func setup() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: {
            //  swiftlint:disable force_cast
            let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            //  swiftlint:enable force_cast
            layout.itemSize = self.itemSize()
        })
    }
    
    private func itemSize() -> CGSize {
        var width = (self.collectionView.frame.width - 32) / 5
        width -= 10
        return CGSize(width: width, height: width)
    }
}
