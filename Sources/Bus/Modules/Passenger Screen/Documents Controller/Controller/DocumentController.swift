//
//  DocumentController.swift
//  MosmetroNew
//
//  Created by Сеня Римиханов on 07.12.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import UIKit

class DocumentController: BaseController {
    
    let mainView = DocumentView.loadFromNib()
    
    var availableDocuments: [Passenger.Document] = [] {
        didSet {
            makeState()
        }
    }
    var selectedDocument: Passenger.Document? {
        didSet {
            makeState()
        }
    }
    
    var onDocSelect: ((Passenger.Document) -> ())?
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .contentIOS
    }
    
    private func makeState() {
        let onClose: () -> () = { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
        
        let docStates: [OldState] = availableDocuments.enumerated().map { (index,doc) in
            let docImage = UIImage.getAssetImage(name: "passport")
            var isSelected = false
            if let current = selectedDocument {
                isSelected = current.code == doc.code
            }
            let onSelect: () -> () = { [weak self] in
                guard let self = self else { return }
                self.selectedDocument = doc
                self.onDocSelect?(doc)
                self.dismiss(animated: true, completion: nil)
            }
            let docData = DocumentView.ViewState.DocData(title: doc.name,
                                                         leftImage: docImage,
                                                         leftImageURL: nil,
                                                         isSelected: isSelected,
                                                         isHidingSeparator: true,
                                                         onSelect: onSelect,
                                                         backgroundColor: .content2)
            let element = Element(content: docData)
            let sectionState = SectionState(id: index+11, header: nil, footer: nil)
            return OldState(model: sectionState, elements: [element])
        }
        self.mainView.viewState = .init(title: "Выберите документ", subtitle: "", items: docStates, onClose: onClose)
    }
}
