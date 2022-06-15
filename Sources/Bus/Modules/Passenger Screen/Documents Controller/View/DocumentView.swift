//
//  DocumentView.swift
//  MosmetroNew
//
//  Created by Сеня Римиханов on 07.12.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import UIKit

class DocumentView: UIView {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var tableView: OldBaseTableView!
    
    @IBAction func handleClose(_ sender: UIButton) {
        viewState.onClose()
    }
    
    struct ViewState {
        let title: String
        let subtitle: String
        let items: [OldState]
        let onClose: () -> ()
        
        struct DocData: _DefaultSelectionCell {
            var title: String
            var leftImage: UIImage?
            var leftImageURL: String?
            var isSelected: Bool
            var isHidingSeparator: Bool
            var onSelect: () -> ()
            var backgroundColor: UIColor
        }
    }
    
    var viewState: ViewState = .init(title: "", subtitle: "", items: [], onClose: {}) {
        didSet {
            DispatchQueue.main.async {
                self.render()
            }
        }
    }
}

extension DocumentView {
    private func render() {
        self.titleLabel.text = viewState.title
        self.descLabel.text = viewState.subtitle
        self.tableView.viewStateInput = viewState.items
    }
}
