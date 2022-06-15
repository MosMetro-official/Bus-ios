//
//  OrderHistoryController.swift
//  MosmetroNew
//
//  Created by Гусейн on 13.12.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import Foundation
import SwiftDate
import Network
import Localize_Swift

class OrderHistoryController: BaseController {
    
    var items: [BusOrder] = [] {
        didSet {
            makeState()
        }
    }
    
    var response: BusOrdersResponse? {
        didSet {
            if let response = response {
                print(response.page, response.totalPages, response.totalElements)
                self.items.append(contentsOf: response.orders)
                print("total items = \(self.items.count)")
            }
        }
    }
    
    private var isLoading = false {
        didSet {
            DispatchQueue.main.async {
                self.mainView.setLoading(isLoading: self.isLoading)
            }
        }
    }
    
    let mainView = OrderHistoryView.loadFromNib()
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "main_bus_history".localized(in: .module)
        self.navigationController?.navigationBar.prefersLargeTitles = false
        mainView.onWillDisplay = { [weak self] displayData in
            guard let self = self else { return }
            let endIndex = self.items.count - 1
            if displayData.indexPath.row == endIndex {
                print("we need to load")
                guard let response = self.response else {
                    return
                }
                if !self.isLoading {
                    if (response.page + 1) <= response.totalPages {
                        self.isLoading = true
                        self.loadHistory(page: response.page + 1, size: 5)
                    }
                }
            }
        }
        self.mainView.viewState = .initial
        self.loadHistory(page: 0, size: 5)
    }
}

extension OrderHistoryController {
    
    private func showDetail(with orderID: Int) {
        DispatchQueue.main.async {
            let cont = OrderDetailController()
            self.present(cont, animated: true, completion: {
                cont.orderID = orderID
            })
        }
    }
    
    private func makeState() {
        let queue = DispatchQueue(label: "ru.mosmetro.busOrders", qos: .userInitiated)
        queue.async { [weak self] in
            guard let self = self else { return }
            let dict = Dictionary.init(grouping: self.items, by: { element -> DateComponents in
                let date = Calendar.current.dateComponents([.day, .month, .year], from: (element.createdDate))
                return date
            })
            let sorted = dict.sorted(by: { $0.key > $1.key })
            let locale = Localize.currentLanguage() == "ru" ? Locales.russianRussia : Locales.english
            let tableItems: [OldState] = sorted.compactMap { date, orders in
                let sortedOrdersInMonth = orders.sorted(by:  { $0.createdDate > $1.createdDate })
                let elements: [Element] = sortedOrdersInMonth.map { order in
                    let onSelect: () -> () = { [weak self] in
                        guard let self = self else { return }
                        self.showDetail(with: order.internalID)
                    }
                    let subtitle = order.bookingStatus == .paid ? "\(order.dispatchDate.toFormat("d MMMM HH:mm", locale: locale))" : order.bookingStatus.text()
                    let orderData = OrderHistoryView.ViewState.Order(
                        title: order.route,
                        subtitle: subtitle ,
                        onSelect: onSelect)
                    return Element(id: order.gdsID, content: orderData)
                }
                guard let first = sortedOrdersInMonth.first else { return nil }
                let title = first.createdDate.toFormat("d MMMM", locale: locale)
                let header = OrderHistoryView.ViewState.TitleHeader(
                    title: title,
                    style: .medium,
                    backgroundColor: .clear,
                    isInsetGrouped: false)
                let section = SectionState(header: header, footer: nil)
                return OldState(model: section, elements: elements)
            }
            self.mainView.viewState.dataState = .loaded(tableItems)
        }
    }
    
    private func loadHistory(page: Int, size: Int) {
        BusOrder.getOrders(size: size, page: page, callback: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let ordersResponse):
                self.response = ordersResponse
                self.isLoading = false
            case .failure(let error):
                self.isLoading = true
                let onRetry = {
                    self.loadHistory(page: 0, size: 5)
                }
                self.mainView.viewState.dataState = .error((error: error, onRetry: onRetry))
            }
        })
    }
}
