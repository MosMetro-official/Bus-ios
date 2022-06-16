//
//  PDFDocView.swift
//  MosmetroNew
//
//  Created by Сеня Римиханов on 11.12.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import UIKit
import PDFKit

class PDFDocView: UIView {
    
    struct ViewState {
        var onSave: () -> ()
        var dataState: DataState
        var onClose: () -> ()
        
        enum DataState {
            case loading
            case loaded(PDFDocument)
            case error(FutureNetworkError)
        }
    }
    
    var viewState: ViewState = .init(onSave: {}, dataState: .loading, onClose: {}) {
        didSet {
            render()
        }
    }
    
    @IBOutlet private weak var pdfView: PDFView!
    
    @IBOutlet private var closeButton: UIButton!
    
    @IBOutlet private weak var saveButton: UIButton!
    
    @IBAction func handleSave(_ sender: UIButton) {
        viewState.onSave()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    @IBAction func handleClose(_ sender: UIButton) {
        viewState.onClose()
    }
}

extension PDFDocView {
    
    private func setup() {
        pdfView.autoScales = true
        saveButton.roundCorners(.all, radius: 8)
    }
    
    private func render() {
        DispatchQueue.main.async {
            switch self.viewState.dataState {
            case .loading:
                self.showLoading()
            case .loaded(let doc):
                self.removeLoading()
                self.pdfView.document = doc
            case .error(let err):
                let state = MetroAlertView.ViewState(style: .warning, title: err.errorDescription, onRetry: nil)
                self.showMetroAlert(with: state, isHiding: true, removeAfter: 10)
            }
        }
    }
}
