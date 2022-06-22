//
//  RideInfoView.swift
//  MosmetroNew
//
//  Created by Гусейн on 18.05.2022.
//  Copyright © 2022 Гусейн Римиханов. All rights reserved.
//

import UIKit

class RideInfoView : UIView {
    
    var onClose: (() -> Void)?
    
    @IBOutlet var closeButton: UIButton!
    
    @IBAction func handleClose(_ sender: UIButton) {
        self.onClose?()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.closeButton.roundCorners(.all, radius: 8)
    }
}
