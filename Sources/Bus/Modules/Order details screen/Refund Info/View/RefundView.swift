//
//  RefundView.swift
//  MosmetroNew
//
//  Created by Гусейн on 22.12.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import UIKit

class RefundView: UIView {
    
    @IBOutlet var successView: UIView!
    @IBOutlet var ticketPriceLabel: UILabel!
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var refundLabel: UILabel!
    @IBOutlet var comissionLabel: UILabel!
    
    struct ViewState {
        let isSuccessHidden: Bool
        let price: String
        let comission: String
        let refund: String
        let onClose: () -> Void
        
        static let initial = ViewState(isSuccessHidden: true,
                                       price: "",
                                       comission: "",
                                       refund: "",
                                       onClose: {})
    }
    
    var viewState: ViewState = .initial {
        didSet {
            render()
        }
    }
    
    @IBAction func handleClose(_ sender: Any) {
        viewState.onClose()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.closeButton.roundCorners(.all, radius: 8)
        successView.roundCorners(.all, radius: 12)
        successView.layer.borderColor = UIColor.metroGreen.cgColor
        successView.layer.borderWidth = 1
    }
}

extension RefundView {
    private func render() {
        self.successView.isHidden = viewState.isSuccessHidden
        self.ticketPriceLabel.text = viewState.price
        self.comissionLabel.text = viewState.comission
        self.refundLabel.text = viewState.refund
    }
}
