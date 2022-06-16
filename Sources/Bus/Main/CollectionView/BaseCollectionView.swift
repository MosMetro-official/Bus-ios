//
//  BaseCollectionView.swift
//  MosmetroNew
//
//  Created by Гусейн on 29.11.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import UIKit
import CoreTableView

typealias CollectionData = (collectionView: UICollectionView, layout: UICollectionViewLayout, indexPath: IndexPath)

class BaseCollectionView : UICollectionView {
    
    public var onSize: ((CollectionData) -> CGSize)?
    public var onPageChange: ((Int) -> ())?
    public var onScroll: ((UIScrollView) -> Void)?
    /// original data source
    private var viewState = [OldState]()
    
    var shouldInterrupt = false
    /// public data source. Affects original, used only for diff calculattions
    public var viewStateInput: [OldState] {
        get {
            return viewState
        }
        set {
            let changeset = StagedChangeset(source: viewState, target: newValue)
            
            self.reload(using: changeset, interrupt: { changeset in return self.shouldInterrupt }) { newState in
                self.viewState = newState
            }
            
        }
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
}

extension BaseCollectionView {
    private func setup() {
        delegate = self
        dataSource = self
        
    }
}

extension BaseCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let elements = viewState[safe: section]?.elements.count {
            return elements
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let element = self.viewState[indexPath.section].elements[indexPath.row].content
        return element.cell(for: collectionView, indexPath: indexPath)
    }
    
}

extension BaseCollectionView: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.onScroll?(scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
        onPageChange?(currentPage)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let element = self.viewState[safe: indexPath.section]?.elements[safe: indexPath.row]?.content {
            element.onSelect()
        }
    }
}
