//
//  OrderHistoryView.swift
//  MosmetroNew
//
//  Created by Гусейн on 13.12.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import UIKit

class OrderHistoryView: UIView {
    
    typealias ErrorData = (error: FutureNetworkError, onRetry: (() -> Void)?)
    
    struct ViewState {
        
        var dataState: DataState
        
        enum DataState {
            case loading(B_MetroLoadingView.ViewState)
            case loaded([OldState])
            case error(ErrorData)
        }
        
        struct Loading: _SmallLoadingCell {}
        
        struct Order: _OrderHistoryCell {
            var title: String
            var subtitle: String
            var onSelect: () -> ()
        }
        
        struct TitleHeader: _B_TitleHeaderView {
            var title: String
            var style: HeaderTitleStyle
            var backgroundColor: UIColor
            var isInsetGrouped: Bool
        }
        
        private static let loadingState = B_MetroLoadingView.ViewState.init(title: "main_bus_history_loading".localized(in: Bus.shared.bundle), subtitle: nil)
        
        static let initial = ViewState(dataState: .loading(loadingState))
    }
    
    private var loadingIndexPath: IndexPath?
    
    var onWillDisplay: ((CellWillDisplayData) -> Void)?
    
    var viewState: ViewState = .initial {
        didSet {
            render()
        }
    }
    
    @IBOutlet var tableView: OldBaseTableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
}

extension OrderHistoryView {
    
    func setLoading(isLoading: Bool) {
        if isLoading {
            let item = Element(id: 777, content: ViewState.Loading())
            let lastIndex = self.tableView.viewStateInput.endIndex - 1
            if let _ = self.tableView.viewStateInput[safe: lastIndex] {
                let lastElement = self.tableView.viewStateInput[lastIndex].elements.count
                self.loadingIndexPath = IndexPath(row: lastElement, section: lastIndex)
                self.tableView.viewStateInput[lastIndex].elements.append(item)
            }
        } else {
            if let iPath = self.loadingIndexPath {
                if let _ = self.tableView.viewStateInput[safe: iPath.section]?.elements[safe: iPath.row] {
                    self.tableView.viewStateInput[iPath.section].elements.remove(at: iPath.row)
                }
            }
        }
    }
    
    private func setup() {
        tableView.shouldInterrupt = true
        tableView.onWillDisplay = { [weak self] data in
            self?.onWillDisplay?(data)
        }
    }
    
    private func render() {
        DispatchQueue.main.async {
            switch self.viewState.dataState {
            case .loading(let loadingState):
                self.showLoading(with: loadingState)
            case .loaded(let tableItems):
                self.removeLoading(completion: nil)
                self.tableView.viewStateInput = tableItems
            case .error(let errData):
                self.removeLoading(completion: nil)
                let errState = MetroAlertView.ViewState(style: .warning, title: errData.error.errorDescription, onRetry: errData.onRetry)
                self.showMetroAlert(with: errState, isHiding: false, removeAfter: 1)
            }
        }
    }
}
