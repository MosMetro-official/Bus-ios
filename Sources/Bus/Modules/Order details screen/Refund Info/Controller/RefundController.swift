//
//  RefundController.swift
//  MosmetroNew
//
//  Created by Гусейн on 22.12.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import Foundation

class RefundController: BaseController {
    
    let mainView = B_RefundView.loadFromNib()
    
    var model: BusOrder.OrderTicket? {
        didSet {
            makeState()
        }
    }
    
    var isSuccesHidden = true
    
    var onClose: (() -> ())?
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .navigationBar
    }
    
    private func makeState() {
        guard let model = model else { return }
        self.mainView.viewState = .init(isSuccessHidden: isSuccesHidden,
                                        price: "\(model.price) ₽",
                                        comission: "\(model.comission) ₽",
                                        refund: "\(model.refundedPrice) ₽",
                                        onClose: { self.onClose?() })
    }
}
