//
//  OnboardingCollectionCell.swift
//  MosmetroNew
//
//  Created by Гусейн on 21.12.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import UIKit

protocol _OnboardingCollectionCell: OldCellData {
    var items: OldState { get }
}

extension _OnboardingCollectionCell {
    func cell(for collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.register(OnboardingCollectionCell.nib, forCellWithReuseIdentifier: OnboardingCollectionCell.identifire)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionCell.identifire, for: indexPath) as? OnboardingCollectionCell else { return .init() }
        cell.configure(data: self)
        cell.parallaxTheImageViewScrollOffset(offsetPoint: collectionView.contentOffset)
        return cell
    }
}

class OnboardingCollectionCell: UICollectionViewCell {
    
    @IBOutlet var tableView: OldBaseTableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 42, right: 0)
    }
    
    func configure(data: _OnboardingCollectionCell) {
        self.tableView.viewStateInput = [data.items]
    }
    
    func parallaxTheImageViewScrollOffset(offsetPoint: CGPoint) {
        let factor: CGFloat = 0.3
        let parallaxFactorX: CGFloat = factor
        let parallaxFactorY: CGFloat =  0.0
        let finalX = (offsetPoint.x - self.frame.origin.x) * parallaxFactorX
        let finalY = (offsetPoint.y - self.frame.origin.y) * parallaxFactorY
        
        if let kek = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? OnboardinImageCell {
            let frame = kek.mainImageView.bounds
            let offsetFrame = frame.offsetBy(dx: CGFloat(finalX), dy: CGFloat(finalY))
            
            kek.mainImageView.frame = offsetFrame
        }
    }
}
