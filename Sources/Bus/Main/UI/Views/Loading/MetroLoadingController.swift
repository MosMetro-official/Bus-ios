//
//  MetroLoadingController.swift
//  MosmetroNew
//
//  Created by Гусейн on 17.12.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import UIKit

class MetroLoadingController: UIViewController {
    
    let loadingView = MetroLoadingView.loadFromNib()
    
    override func loadView() {
        super.loadView()
        self.view = loadingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //loadingView.configure(with: .init(title: "Loading".localized(), subtitle: nil, isUsingBlur: true))
    }
}
