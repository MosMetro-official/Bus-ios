//
//  B_TitleHeaderView.swift
//  MosmetroNew
//
//  Created by Гусейн on 10.11.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import UIKit

protocol _B_TitleHeaderView {
    
    var title: String { get set }
    var style: HeaderTitleStyle { get set }
    var backgroundColor: UIColor { get set }
    var isInsetGrouped: Bool { get set }
}

class B_TitleHeaderView : UITableViewHeaderFooterView {
    
    @IBOutlet private weak var leftLabelConstaint: NSLayoutConstraint!
    @IBOutlet private weak var backView: UIView!
    @IBOutlet private weak var mainTitleLabel: UILabel!
    
    public func configure(_ data: _B_TitleHeaderView) {
        self.mainTitleLabel.font = data.style.font()
        self.mainTitleLabel.text = data.title
        self.backView.backgroundColor = data.backgroundColor
        self.leftLabelConstaint.constant = data.isInsetGrouped ? 20 : 16
        self.layoutIfNeeded()
    }
}
