//
//  BusRideInfoController.swift
//  MosmetroNew
//
//  Created by Гусейн on 18.05.2022.
//  Copyright © 2022 Гусейн Римиханов. All rights reserved.
//

import Foundation

class BusRideInfoController: BaseController {
    
    var onClose: (() -> Void)?
    
    let mainView = RideInfoView.loadFromNib()
    
    override func loadView() {
        super.loadView()
        self.view = mainView
        mainView.onClose = { [weak self] in
            self?.onClose?()
        }
    }
}
