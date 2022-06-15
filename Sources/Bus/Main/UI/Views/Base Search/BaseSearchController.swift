//
//  BaseSearchController.swift
//  MosmetroNew
//
//  Created by Сеня Римиханов on 11.11.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import UIKit

class BaseSearchController: BaseController {
    
    let mainView = BaseSearchView.loadFromNib()
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

extension BaseSearchController {
    
    private func setup() {
        self.view.backgroundColor = .baseIOS
        mainView.onDismiss = { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: nil)
        }
    }
}
