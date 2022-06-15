//
//  RagePanelVC.swift
//  MosmetroNew
//
//  Created by Павел Кузин on 23.11.2020.
//  Copyright © 2020 Гусейн Римиханов. All rights reserved.
//

import UIKit

class AlertView: UIView {
    
    var starCounter = 0
    
    var onClose         : (() -> ())?
    var openRagePanel   : (() -> ())?
    var openStoreReview : (() -> ())?
    
    @IBOutlet weak var contentView  : UIView!
    @IBOutlet weak var titleLabel   : UILabel!
    @IBOutlet var starButton        : [UIButton]!
    @IBOutlet weak var dismisButton : UIButton!

    @IBAction func starButtonTaped(_ sender: UIButton) {
        for  button in starButton {
            if button.tag - 1 >= sender.tag {
                button.setBackgroundImage(UIImage(named: "NO_Rating_Star_"), for: .normal)   //selectted
            } else {
                button.setBackgroundImage(UIImage(named: "Rating_Star"), for: .normal) //not selectted
                starCounter += 1
            }
        }
        if starCounter >= 4 {
            self.openStoreReview?()
        } else {
            self.openRagePanel?()
        }
    }
    
    @IBAction func dissmisButtonTaped(_ sender: Any) {
        self.onClose?()
        setNoStars()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = "How do you like the app?".localized(in: .module)
        dismisButton.setTitle("Cancel".localized(in: .module), for: .normal)
    }
    
    func setNoStars() {
        starButton.forEach {
            $0.setBackgroundImage(UIImage(named: "NO_Rating_Star_"), for: .normal)
        }
        starCounter = 0
    }
}
