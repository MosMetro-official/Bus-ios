//
//  OrderDetailsView.swift
//  MosmetroNew
//
//  Created by Гусейн on 10.12.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import UIKit

class OrderDetailsView: UIView {
        
    struct ViewState {
        
        var dataState: DataState
        var onClose: () -> ()
        
        enum DataState {
            case loading(MetroLoadingView.ViewState)
            case loaded([OldState])
            case error(FutureNetworkError)
        }
        
        struct RideInfo: _RideInfoTableViewCell {
            var onSelect: () -> ()
        }
        
        struct NeedToPay: _NeedToPayCell {
            var title: String
            var onSelect: () -> ()
        }
        
        struct OrderTitle: _OrderTitleCell {
            var title: String
            var subtitle: String
        }
 
        struct Start: _TicketStartCell {
            var title: String
            var subtitle: String
        }
        
        struct Attribute: _TicketAttributeCell {
            var image: UIImage
            var name: String
            var value: String
        }
        
        struct Ticket: _TicketDetailCell {
            var status: BusOrder.BookingStatus
            var onRefundDetails: () -> ()
            var downloadTitle: String
            var number: String
            var price: String
            var passenger: String
            var place: String
            var onRefund: () -> ()
            var onDownload: () -> ()
        }
        
        struct Title: _TitleHeaderView {
            var title: String
            var style: HeaderTitleStyle
            var backgroundColor: UIColor
            var isInsetGrouped: Bool
        }
        
        struct End: _TicketArrivalCell {
            var title: String
            var subtitle: String
        }
        
        static let initial = ViewState(dataState: .loading(.init(title: "main_bus_loading_order_data".localized(in: .module), subtitle: nil)), onClose: {})
    }
    
    var viewState: ViewState = .initial {
        didSet {
            render()
        }
    }
    
    @IBOutlet private var closeButton: UIButton!
    @IBOutlet private var tableView: OldBaseTableView!
    
    @IBAction private func handleClose(_ sender: UIButton) {
        viewState.onClose()
    }
}

extension OrderDetailsView {
    private func render() {
        DispatchQueue.main.async {
            switch self.viewState.dataState {
            case .loading(let loadingState):
                self.showLoading(with: loadingState)
            case .loaded(let tableData):
                self.removeLoading()
                self.tableView.viewStateInput = tableData
            case .error(let error):
                self.removeLoading {
                    self.showMetroAlert(with: .init(style: .warning, title: error.errorDescription, onRetry: nil))
                }
            }
        }
    }
}
