//
//  TicketDetailsController.swift
//  MosmetroNew
//
//  Created by Гусейн on 17.11.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import UIKit
import SwiftDate
import ViewAnimator
import SafariServices
import Localize_Swift

class TicketDetailsController: BaseController {
    
    let mainView = TicketDetailsView.loadFromNib()
    
    var raceUID: String? {
        didSet {
            loadSummary()
        }
    }
    
    let busTicketService = BusTicketService()
    
    private var paymentWebController: SFSafariViewController?
    
    var paymentModel: BusPaymentModel? {
        didSet {
            makeState()
        }
    }
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainView.viewState = .initial
        busTicketService.setupPaymentObserver()
        busTicketService.onPaymentSuccess = { [weak self] in
            guard let self = self else { return }
            self.startConfirm()
        }
    }
}

extension TicketDetailsController {
    
    @objc
    private func handleAuth() {
        self.mainView.viewState.unauthorized = nil
        startPayment()
    }
    
    private func showOrderDetail(with order: BusOrder) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            let cont = OrderDetailController()
            self.present(cont, animated: true, completion: {
                cont.order = order
            })
        })
    }
    
    private func startConfirm() {
        self.paymentWebController?.dismiss(animated: true, completion: nil)
        self.mainView.viewState.dataState = .loading(.init(title: "main_bus_comfirming_order".localized(in: Bus.shared.bundle), subtitle: nil, isUsingBlur: true))
        self.busTicketService.confirmPayment(callback: { result in
            switch result {
            case .success(let order):
                self.mainView.viewState.dataState = .loaded
                self.showOrderDetail(with: order)
            case .failure(let error):
                self.mainView.viewState.dataState = .error(error)
            }
        })
    }
    
    private func handle(order: OrderBookingResponse) {
        DispatchQueue.main.async {
            self.mainView.viewState.dataState = .loaded
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                print(order.url)
                self.paymentWebController = self.openWeb(link: order.url)
            })
        }
    }
    
    private func startPayment() {
        if Constants.userAuthorized() {
//            AnalyticsService.reportEvent(with: "newmetro.city.buybustickets.race.tap.buy")
            guard let body = self.paymentModel?.createPaymentRequestBody() else { return }
            self.mainView.viewState.dataState = .loading(.init(title: "main_bus_sending_order".localized(in: Bus.shared.bundle), subtitle: nil, isUsingBlur: true))
            busTicketService.initPayment(body: body, callback: { result in
                switch result {
                case .success(let orderResponse):
                    self.handle(order: orderResponse)
                case .failure(let error):
                    self.mainView.viewState.dataState = .error(error)
                }
            })
        } else {
            let model = ParkingUnauthorizedModel(buttonText: "log_in".localized(in: Bus.shared.bundle), image: UIImage.getAssetImage(name: "Bus Illustration"), title: "main_bus_auth_title".localized(in: Bus.shared.bundle), subtitle: "main_bus_auth_desc".localized(in: Bus.shared.bundle), onClose: { [weak self] in
                self?.mainView.viewState.unauthorized = nil
            }, onAction: { [weak self] in
//                self?.showAuthScreen()
                Bus.shared.authDelegate?.showAuthScreen(completion: { authScreen in
                    self?.present(authScreen, animated: true)
                })
            })
            self.mainView.viewState.unauthorized = model
        }
    }
    
    private func createPaymentModel(from race: RaceSummary) {
        let paymentMethod = BusPaymentMethod(image: BusPaymentMethod.MethodType.bank.image(), title: "Bank card".localized(in: Bus.shared.bundle), type: .bank)
        self.paymentModel = .init(raceSummary: race, tickets: nil, paymentMethod: paymentMethod)
    }
    
    private func loadSummary() {
        if let uid = raceUID {
            busTicketService.raceSummary(by: uid, callback: { result in
                switch result {
                case .success(let raceSummary):
                    self.createPaymentModel(from: raceSummary)
                case .failure(let error):
                    self.mainView.viewState.dataState = .error(error)
                }
            })
        }
    }
    
    private func showPassengerController() {
//        AnalyticsService.reportEvent(with: "newmetro.city.buybustickets.race.tap.passenger")
        let controller = PassengerController()
        controller.model = self.paymentModel
        controller.onSave = { [weak self] payment in
            self?.paymentModel = payment
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    private func canPay() -> Bool {
        return paymentModel != nil && paymentModel?.tickets != nil
    }
    
    private func createAttributesSection() -> OldState {
        var items: [TicketDetailsView.ViewState.Attribute] = []
        if let model = paymentModel {
            let freeSeatsImg = UIImage.getAssetImage(name: "Place")
            let freeSeatsAttr = TicketDetailsView.ViewState.Attribute(image: freeSeatsImg, name: "main_bus_seats_free1".localized(in: Bus.shared.bundle), value: "\(model.raceSummary.seats.count)")
            let timeOnTheWayImg = UIImage.getAssetImage(name: "clock-time-menu")
            let timeOnTheWay = TicketDetailsView.ViewState.Attribute(image: timeOnTheWayImg, name: "main_bus_time".localized(in: Bus.shared.bundle), value: Utils.getTotalTimeString(from: model.raceSummary.race.duration) ?? "")
            let carrierImg = UIImage.getAssetImage(name: "steering-wheel")
            let carrier = TicketDetailsView.ViewState.Attribute(image: carrierImg, name: "main_bus_driver".localized(in: Bus.shared.bundle), value: model.raceSummary.race.carrier.name)
            let ticketsImg = UIImage.getAssetImage(name: "airline-ticket")
            let tickets = model.raceSummary.ticketTypes.map { ticket in
                TicketDetailsView.ViewState.Attribute(image: ticketsImg, name: "\("main_bus_ticket".localized(in: Bus.shared.bundle)) \(ticket.name)", value: "\(ticket.price) ₽")
            }
            items.append(contentsOf: [freeSeatsAttr,timeOnTheWay,carrier])
            items.append(contentsOf: tickets)
        }
        let header = TicketDetailsView.ViewState.Header(
            title: "Detailed info".localized(in: Bus.shared.bundle),
            style: .medium,
            backgroundColor: .clear,
            isInsetGrouped: false
        )
        let sec = SectionState(header: header, footer: nil)
        return OldState(model: sec, elements: items.map { Element(content: $0) })
    }
    
    private func makeState() {
        if let model = paymentModel {
            let locale = Localize.currentLanguage() == "ru" ? Locales.russianRussia : Locales.english
            let startPointSubtitle = model.raceSummary.race.dispatchDate.toFormat("d MMMM HH:mm", locale: locale)
            let startPoint = TicketDetailsView.ViewState.StartPoint(title: model.raceSummary.race.dispatchStationName, subtitle: startPointSubtitle)
            let passengerSelectTitle = model.tickets == nil ? "Not selected".localized(in: Bus.shared.bundle) : "Выбрано \(model.tickets!.count)"
            let select1 = TicketDetailsView.ViewState.SelectRow(image: UIImage.getAssetImage(name: "UserProfile"), title: "main_bus_passengers".localized(in: Bus.shared.bundle), subtitle: passengerSelectTitle, subtitleColor: .textSecondary, onSelect: {
                self.showPassengerController()
            })
            let select2 = TicketDetailsView.ViewState.SelectRow(image: UIImage.getAssetImage(name: "credit-card-add-plus"), title: "Payment method".localized(in: Bus.shared.bundle), subtitle: model.paymentMethod.title, subtitleColor: .main, onSelect: {
                let alert = UIAlertController(title: "Пока только карты", message: "Мы принимаем оплату только банковскими картами. Скоро тут появится Apple Pay", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Got it".localized(in: Bus.shared.bundle), style: .cancel, handler: { _ in
                    alert.dismiss(animated: true, completion: nil)
                })
                
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            })
            let endPointSubtitle = model.raceSummary.race.arrivalDate.toFormat("d MMMM HH:mm", locale: locale)
            let endPoint = TicketDetailsView.ViewState.EndPoint(title: model.raceSummary.race.arrivalStationName, subtitle: endPointSubtitle)
            let elements = [startPoint,select1,select2,endPoint].enumerated().map { Element(content: $0.element) }
            let header = TicketDetailsView.ViewState.Header(
                title: "Route details".localized(in: Bus.shared.bundle),
                style: .medium,
                backgroundColor: .clear,
                isInsetGrouped: false
            )
            let mainSection = SectionState(header: header, footer: nil)
            let state = OldState(model: mainSection, elements: elements)
            let onPay: () -> () = { [weak self] in
                self?.startPayment()
            }
            self.mainView.viewState = .init(
                title: model.raceSummary.race.raceTitle,
                subtitle: startPointSubtitle,
                price: "\(model.totalPrice) ₽",
                onPay: self.canPay() ? onPay : nil,
                tableItems: [
                    self.createAttributesSection(),
                    state
                ],
                dataState: .loaded
            )
        }
    }
}
