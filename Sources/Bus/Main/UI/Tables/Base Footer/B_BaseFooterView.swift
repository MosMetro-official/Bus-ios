//
//  B_BaseFooterView.swift
//  MosmetroNew
//
//  Created by Гусейн on 10.11.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import UIKit

protocol _B_BaseFooterView {
    var text : String { get set }
    var attributedText : NSAttributedString? { get set }
    var isInsetGrouped : Bool { get }
}

class B_BaseFooterView: UITableViewHeaderFooterView {

    @IBOutlet weak var leftLabelAnchor : NSLayoutConstraint!
    
    @IBOutlet weak var mainTitle : UILabel!
    
    public func configure(_ data: _B_BaseFooterView) {
        if let attributedText = data.attributedText {
            mainTitle.attributedText = attributedText
        } else {
            mainTitle.text = data.text
        }
        self.leftLabelAnchor.constant = data.isInsetGrouped ? 32 : 16
        self.layoutIfNeeded()
    }
}
