//
//  PDFDocumentController.swift
//  MosmetroNew
//
//  Created by Сеня Римиханов on 11.12.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import UIKit
import PDFKit

class PDFDocumentController: BaseController {
    
    let pdfView = PDFDocView.loadFromNib()
    
//    var document: PDFDocument? {
//        didSet {
//            makeState()
//        }
//    }
    
    var filePath: URL? {
        didSet {
            makeState()
        }
    }
    
    var ticket: BusOrder.OrderTicket? {
        didSet {
            if let ticket = ticket {
                let service = BusTicketService()
                service.loadDocument(ticket: ticket, callback: { result in
                    switch result {
                    case .success(let filePath):
                        self.filePath = filePath
                    case .failure(let error):
                        self.pdfView.viewState.dataState = .error(error)
                    }
                })
            }
        }
    }
    
    override func loadView() {
        super.loadView()
        self.view = pdfView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let onClose: () -> () = {
            self.dismiss(animated: true)
        }
        self.pdfView.viewState = .init(onSave: {}, dataState: .loading, onClose: onClose)
    }
}

extension PDFDocumentController {
    
    private func makeState() {
        if let filePath = self.filePath {
            let onSave: () -> () = { [weak self] in
                guard let self = self else { return }
//                AnalyticsService.reportEvent(with: "newmetro.cabinet.mybustickets.orders.download.tap.save")
                let activityViewController = UIActivityViewController(activityItems: [filePath], applicationActivities: nil)
                self.present(activityViewController, animated: true, completion: nil)
            }
            if let pdfDoc = PDFDocument(url: filePath) {
                self.pdfView.viewState = .init(onSave: onSave, dataState: .loaded(pdfDoc), onClose: self.pdfView.viewState.onClose)
            }
        }
    }
}
