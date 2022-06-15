//
//  OrderDetailController.swift
//  MosmetroNew
//
//  Created by Гусейн on 10.12.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import Foundation
import PDFKit
import SwiftDate
import Localize_Swift
import SafariServices

class OrderDetailController: BaseController {
    
    let orderView = OrderDetailsView.loadFromNib()
    private let busTicketService = BusTicketService()
    private var paymentWebController: SFSafariViewController?
    
    var order: BusOrder? {
        didSet {
            makeState()
        }
    }
    
    var orderID: Int? {
        didSet {
            loadOrder()
        }
    }
    
    override func loadView() {
        super.loadView()
        self.view = orderView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

extension OrderDetailController {
    private func loadOrder() {
        if let orderId = orderID {
            BusOrder.getOrder(by: orderId, callback: { result in
                switch result {
                case .success(let response):
                    self.order = response
                case .failure(let err):
                    self.orderView.viewState.dataState = .error(err)
                }
            })
        }
    }
    
    private func refund(_ ticket: BusOrder.OrderTicket) {
        if let order = order {
            self.orderView.viewState.dataState = .loading(.init(title: "main_bus_refunding".localized(in: .module), subtitle: "main_bus_please_wait".localized(in: .module), isUsingBlur: true))
            order.refundTicket(ticket: ticket, callback: { result in
                switch result {
                case .success(let ticket):
                    self.loadOrder()
                    DispatchQueue.main.async {
                        self.showRefund(for: ticket, fromRefund: true)
                    }
                case .failure(let err):
                    self.orderView.viewState.dataState = .error(err)
                }
            })
        }
    }
    
    private func setup() {
        self.view.backgroundColor = .contentIOS
        let onClose: () -> () = { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
        busTicketService.setupPaymentObserver()
        busTicketService.onPaymentSuccess = { [weak self] in
            guard let self = self else { return }
            self.startConfirm()
        }
        self.orderView.viewState = .init(dataState: .loading(.initial), onClose: onClose)
    }
    
    private func showRefund(for ticket: BusOrder.OrderTicket, fromRefund: Bool) {
        let refundVC = RefundController()
        let fpc = FloatingService.getPanel(contentVC: refundVC, positions: .modalCenter, state: .half)
        fpc.layout = RefundPanelLayout()
        fpc.surfaceView.backgroundColor = .baseIOS
        fpc.surfaceView.grabberHandle.isHidden = true
        let animator = UIViewPropertyAnimator(duration: 0.25, curve: .easeInOut) {
            fpc.move(to: .half, animated: false, completion: nil)
        }
        fpc.addPanel(toParent: self, completion: {
            refundVC.isSuccesHidden = !fromRefund
            refundVC.model = ticket
            refundVC.onClose = {
                fpc.removePanelFromParent(animated: true, completion: nil)
            }
            fpc.invalidateLayout()
            animator.startAnimation()
        })
    }
    
    private func showRideInfo() {
        let infoVC = BusRideInfoController()
        let fpc = FloatingService.getPanel(contentVC: infoVC, positions: .modalCenter, state: .half)
        fpc.layout = RefundPanelLayout()
        fpc.surfaceView.backgroundColor = .baseIOS
        fpc.surfaceView.grabberHandle.isHidden = true
        let animator = UIViewPropertyAnimator(duration: 0.25, curve: .easeInOut) {
            fpc.move(to: .half, animated: false, completion: nil)
        }
        fpc.addPanel(toParent: self, completion: {
            infoVC.onClose = {
                fpc.removePanelFromParent(animated: true, completion: nil)
            }
            fpc.invalidateLayout()
            animator.startAnimation()
        })
    }
    
    private func showRefundConfirmation(for ticket: BusOrder.OrderTicket) {
        let alert = UIAlertController(title: "main_bus_refund_alert_title".localized(in: .module), message: "main_bus_refund_alert_desc".localized(in: .module), preferredStyle: .alert)
        let okAction = UIAlertAction(title: "main_bus_refund_alert".localized(in: .module), style: .destructive, handler: { _ in
            alert.dismiss(animated: true, completion: { [weak self] in
//                AnalyticsService.reportEvent(with: "newmetro.cabinet.mybustickets.orders.tap.return")
                self?.refund(ticket)
            })
        })
        
        let cancelAction = UIAlertAction(title: "parking_missclick".localized(in: .module), style: .default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        })
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func startConfirm() {
        guard let order = order else { return }
        self.paymentWebController?.dismiss(animated: true, completion: nil)
        self.orderView.viewState.dataState = .loading(.init(title: "main_bus_comfirming_order".localized(in: .module), subtitle: nil, isUsingBlur: true))
        OrderProcessingService.shared.order = OrderBookingResponse(internalOrderID: order.internalID, sberbankOrderID: order.sberbankID, gdsID: order.gdsID, url: "")
        self.busTicketService.confirmPayment(callback: { result in
            switch result {
            case .success(let order):
                self.order = order
            case .failure(let error):
                self.orderView.viewState.dataState = .error(error)
            }
        })
    }
    
    private func showDocumentController(with ticket: BusOrder.OrderTicket) {
        DispatchQueue.main.async {
            let pdfController = PDFDocumentController()
            self.present(pdfController, animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
                pdfController.ticket = ticket
            })
        }
    }
    
    private func pay() {
//        AnalyticsService.reportEvent(with: "newmetro.cabinet.mybustickets.orders.tap.buy")
        if let order = self.order {
            let link = "https://securepayments.sberbank.ru/payment/merchants/sbersafe_sberid/payment_ru.html?mdOrder=\(order.sberbankID)"
            self.paymentWebController = self.openWeb(link: link)
        }
    }
    
    private func attributes(for order: BusOrder) -> OldState {
        let statusImg = UIImage.getAssetImage(name: "loading-checkmark-status-circle")
        let bookStatus = Element(content:
                                    OrderDetailsView.ViewState.Attribute(image: statusImg, name: "main_bus_book_status".localized(in: .module), value: order.bookingStatus.text())
        )
        
        let paymentStatus = Element(content:
                                        OrderDetailsView.ViewState.Attribute(image: statusImg, name: "main_bus_payment_status".localized(in: .module), value: order.paymentInfo?.status.text() ?? "")
        )
        
        let moscow  = Region(calendar: Calendars.gregorian, zone: Zones.europeMoscow, locale: Locales.russian)
        
        //convertTo(region: moscow).toFormat("HH:mm", locale: Locales.russianRussia)
        let dateImg = UIImage.getAssetImage(name: "calendar-schedule")
        let paymentDate = Element(content:
                                    OrderDetailsView.ViewState.Attribute(image: dateImg, name: "main_bus_payment_date".localized(in: .module), value: order.paymentInfo?.date.convertTo(region: moscow).toFormat("d MMMM yyyy HH:mm", locale: Locales.russianRussia) ?? "")
        )
        let paymentImg = UIImage.getAssetImage(name: "credit-card-add-plus")
        let paymentMethod = Element(content:
                                        OrderDetailsView.ViewState.Attribute(image: paymentImg, name: "Payment method".localized(in: .module), value: order.paymentInfo?.paymentWay.text() ?? "")
        )
        let codeImg = UIImage.getAssetImage(name: "Barcode")
        let reserveCode = Element(content:
                                    OrderDetailsView.ViewState.Attribute(image: codeImg, name: "main_bus_reserve_code".localized(in: .module), value: order.reserveCode)
        )
        let priceImg = UIImage.getAssetImage(name: "parking_ruble")
        let totalPrice = Element(content:
                                    OrderDetailsView.ViewState.Attribute(image: priceImg, name: "main_bus_total_price_1".localized(in: .module), value: "\(order.totalPrice) ₽")
        )
        
        let header = OrderDetailsView.ViewState.Title.init(title: "Detailed info".localized(in: .module), style: .small, backgroundColor: .clear, isInsetGrouped: false)
        let secState = SectionState(header: header, footer: nil)
        return OldState(model: secState, elements: [bookStatus,paymentStatus,paymentDate,paymentMethod,reserveCode,totalPrice])
    }
    
    private func makeState() {
        if let order = order {
            let params: [String: Any] = [
                "id": order.internalID,
                "from": order.tickets.first?.dispatchStation ?? "",
                "to": order.tickets.first?.arrivalStation ?? "",
                "paymentStatus": order.paymentInfo?.status.text() ?? "",
                "bookingStatus": order.bookingStatus.text(),
                "paymentDate": order.paymentInfo?.date.toFormat("d MMMM yyyy HH:mm") ?? "",
                "paymentMethod": order.paymentInfo?.paymentWay.text() ?? "",
                "ticketCount": order.tickets.count
            ]
//            AnalyticsService.reportEvent(with: "newmetro.cabinet.mybustickets.orders.detail", parameters: params)
            var sections = [OldState]()
            let locale = Localize.currentLanguage() == "ru" ? Locales.russianRussia : Locales.english
            
            let firstSec = SectionState(header: nil, footer: nil)
            var firstElements = [Element]()
            let title = Element(content:
                                    OrderDetailsView.ViewState.OrderTitle(title: "main_bus_order_details".localized(in: .module), subtitle: "№ \(order.gdsID)")
            )
            
            let info = OrderDetailsView.ViewState.RideInfo { [weak self] in
                self?.showRideInfo()
            }.toElement()
            
            firstElements.append(title)
            firstElements.append(info)
            if let firstTicket = order.tickets.first {
                
                // MARK: Route section
                let start = Element(content:
                                        OrderDetailsView.ViewState.Start(title: firstTicket.dispatchDate.toFormat("d MMMM HH:mm", locale: locale), subtitle: "\(firstTicket.dispatchStation) • \(firstTicket.dispatchAdress)")
                )
                let end = Element(content:
                                    OrderDetailsView.ViewState.End(title: firstTicket.arrivalDate.toFormat("d MMMM HH:mm", locale: locale), subtitle: firstTicket.arrivalStation)
                )
                firstElements.append(contentsOf: [start,end])
            }
            
            if order.paymentInfo?.status == .registered {
                let onSelect: () -> () = { [weak self] in
                    self?.pay()
                    
                }
                let needToPay = Element(content:
                                            OrderDetailsView.ViewState.NeedToPay(title: "main_bus_need_to_pay".localized(in: .module), onSelect: onSelect)
                )
                firstElements.append(needToPay)
            }
            
            sections.append(OldState(model: firstSec, elements: firstElements))
            
            // MARK: Attributes section
            sections.append(attributes(for: order))
            
            // MARK: Tickets
            let ticketHeader = OrderDetailsView.ViewState.Title(title: "Tickets".localized(in: .module), style: .small, backgroundColor: .clear, isInsetGrouped: false)
            let tickets: [OrderDetailsView.ViewState.Ticket] = order.tickets.map { ticket in
                
                let onDownload: () -> () = { [weak self] in
//                    AnalyticsService.reportEvent(with: "newmetro.cabinet.mybustickets.orders.tap.download")
                    guard let self = self else { return }
                    self.showDocumentController(with: ticket)
                }
                
                let onRefund: () -> () = { [weak self] in
                    guard let self = self else { return }
                    self.showRefundConfirmation(for: ticket)
                }
                let onRefundDetails: () -> () = { [weak self] in
//                    AnalyticsService.reportEvent(with: "newmetro.cabinet.mybustickets.orders.tap.returndetails")
                    guard let self = self else { return }
                    self.showRefund(for: ticket, fromRefund: false)
                }
                
                return .init(status: ticket.status,
                             onRefundDetails: onRefundDetails,
                             downloadTitle: ticket.refundDate == nil ? "main_bus_load".localized(in: .module) : "main_bus_refund_doc".localized(in: .module),
                             number: "\(ticket.ticketCode)",
                             price: "\(ticket.price) ₽",
                             passenger: ticket.passengerData,
                             place: ticket.seat,
                             onRefund:  onRefund,
                             onDownload: onDownload)
                
            }
            
            let ticketSection = SectionState(header: ticketHeader, footer: nil)
            sections.append(OldState(model: ticketSection, elements: tickets.map { Element(content: $0) }))
            self.orderView.viewState.dataState = .loaded(sections)
        }
    }
}
