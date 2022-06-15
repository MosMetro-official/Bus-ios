//
//  BusPlaceCollectionCell.swift
//  MosmetroNew
//
//  Created by Гусейн on 03.12.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import UIKit

protocol _BusPlaceCollectionCell: OldCellData {
    var text: String { get }
    var isSelected: Bool { get }
    var onSelect: () -> () { get }
    var isUnvailable: Bool { get }
}

extension _BusPlaceCollectionCell {
    func cell(for collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.register(BusPlaceCollectionCell.nib, forCellWithReuseIdentifier: BusPlaceCollectionCell.identifire)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BusPlaceCollectionCell.identifire, for: indexPath) as? BusPlaceCollectionCell else { return .init() }
        cell.configure(data: self)
        return cell
    }
}

class BusPlaceCollectionCell: UICollectionViewCell {

    @IBOutlet private var backView: UIView!
    @IBOutlet private var numberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.roundCorners(.all, radius: 16)
    }
    
    func configure(data: _BusPlaceCollectionCell) {
        self.numberLabel.text = data.text
        self.backView.backgroundColor = data.isSelected ? .buttonSecondary : .content2
        self.numberLabel.textColor = data.isSelected ? .invertedText : .textPrimary
        self.backView.layer.borderColor = data.isSelected ? UIColor.main.cgColor : UIColor.clear.cgColor
        self.backView.layer.borderWidth = data.isSelected ? 1 : 0
        self.backView.alpha = data.isUnvailable ? 0.4 : 1
    }
}
