//
//  BusTicketHomeController.swift
//  MosmetroNew
//
//  Created by Гусейн on 16.11.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import UIKit
import SwiftDate
import ViewAnimator
import Localize_Swift

class BusTicketHomeController: BaseController {
    
    private let mainView = BusTicketHomeView.loadFromNib()
    
    private let service = BusTicketService()
    
    private var model: TicketSearchModel? {
        didSet {
            if let from = model?.from?.from, let to = model?.to?.to, let date = model?.date {
                loadRaces(from: from, to: to, date: date)
            }
            makeState()
        }
    }
    
    private var races: TicketSearchModel.ModelState = .initial {
        didSet {
            makeState()
        }
    }
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    public var isHidingNavigation = false
    
    //https://devapp.mosmetro.ru/services/busticketsales/gds/v1/races/5107/128463/2021-12-0
    override func viewDidLoad() {
        super.viewDidLoad()
        print("CURRENT LANGUAGE 🔥🔥🔥 \(Localize.currentLanguage())")
        self.title = "main_bus_race_find".localized(in: .module)
        self.view.backgroundColor = .baseIOS
        if !BusTicketService.hasSeenOnboarding {
            let onboarding = OnboardingController()
            onboarding.modalTransitionStyle = .crossDissolve
            onboarding.modalPresentationStyle = .fullScreen
            onboarding.onClose = {
                BusTicketService.hasSeenOnboarding = true
                onboarding.dismiss(animated: true, completion: nil)
            }
            self.present(onboarding, animated: true) {
                onboarding.onboardingName = "onboarding_ios_buses".localized(in: .module)
            }
        }
        self.model = .init(from: .init(country: nil, region: nil, from: nil), to: nil, date: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

extension BusTicketHomeController {
    
    private func showError(_ error: FutureNetworkError) {
        DispatchQueue.main.async {
            self.mainView.tableView.showError(title: "Error".localized(in: .module), desc: error.errorDescription, onRetry: nil)
        }
    }
    
    private func loadRaces(from: Destination, to: Destination, date: Date) {
        self.races = .loading
        service.findRaces(from: from, to: to, onDate: date, callback: { result in
            switch result {
            case .success(let races):
                self.races = .loaded(races)
            case .failure(let error):
                self.races = .error(error)
            }
        })
    }
    
    private func showDatePicker() {
        let datePicker = B_MKDatePicker.loadFromNib()
        datePicker.datePicker.datePickerMode = .date
        let currentDate = Date()
        datePicker.datePicker.date = self.model?.date ?? currentDate
        datePicker.setMinimumDate(currentDate)
        datePicker.onDateChange = { [weak self] date in
            self?.model?.date = date
            datePicker.removeFromSuperview()
        }
        
//        datePicker.onDoneSelect = { [weak self] date in
//            self?.model?.date = date
//        }
        
        datePicker.pin(on: self.view) {[
            $0.topAnchor.constraint(equalTo: $1.safeAreaLayoutGuide.topAnchor, constant: 20),
            $0.centerXAnchor.constraint(equalTo: $1.centerXAnchor),
            $0.widthAnchor.constraint(equalTo: $1.widthAnchor, multiplier: 0.9)
        ]}
    }
    
    private func showSearchController(direction: Direction) {
        let controller = BusDestinationSearchController()
        controller.modalTransitionStyle = .crossDissolve
        controller.modalPresentationStyle = .fullScreen
        switch direction {
        case .from:
            controller.departureModel = self.model?.from
        case .to:
            controller.arrivalModel = self.model?.to
        }
        controller.onDestinationSelect = { [weak self] destination in
            guard let self = self else { return }
            if let departure = destination as? DepartureSearchModel {
                self.model?.from = departure
                if let fromDestination = departure.from {
                    self.model?.to = .init(from: fromDestination, to: nil)
                }
            }
            if let arrival = destination as? ArrivalSearchModel {
                self.model?.to = arrival
            }
        }
        self.present(controller, animated: true, completion: nil)
        //controller.direction = direction
        //        controller.onStationSelect = { [weak self] station in
        //            guard let self = self else { return }
        //            self.setStation(direction, station)
        //        }
    }
    
    private func showDetails(race: Race) {
        //        AnalyticsService.reportEvent(with: "newmetro.city.buybustickets.tap.race")
        DispatchQueue.main.async {
            let controller = TicketDetailsController()
            controller.raceUID = race.id
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    private func makeState() {
        if let model = model {
            let fromField = BusTicketHomeView.ViewState.Field(placeholder: "choose_from".localized(in: .module), text: model.from?.from?.name, onSelect: { [weak self] in
                self?.showSearchController(direction: .from)
            })
            let toField = BusTicketHomeView.ViewState.Field(placeholder: "choose_where_to".localized(in: .module), text: model.to?.to?.name, onSelect: { [weak self] in
                self?.showSearchController(direction: .to)
            })
            let dateStr = model.date?.toFormat("dd MMM yyyy", locale: Locales.russian)
            let dateField = BusTicketHomeView.ViewState.Field(placeholder: "select_a_date".localized(in: .module), text: dateStr, onSelect: { [weak self] in
                self?.showDatePicker()
            })
            self.mainView.viewState = .init(dataState: self.mainView.viewState.dataState, from: fromField, to: toField, date: dateField)
            switch races {
            case .initial:
                let img = UIImage.getAssetImage(name: "Bus_illustration")
                let initialData = Element(content: BusTicketHomeView.ViewState.Placeholder(
                    title: "main_bus_initial_title".localized(in: .module),
                    subtitle: "main_bus_initial_subtitle".localized(in: .module),
                    image: img)
                )
                let initialSection = SectionState(header: nil, footer: nil)
                let initialSectionState = OldState(model: initialSection, elements: [initialData])
                self.mainView.viewState.dataState = .initial([initialSectionState])
            case .loading:
                self.mainView.viewState.dataState = .loading(.init(title: "Loading...".localized(in: .module), subtitle: nil, isUsingBlur: true))
            case .loaded(let races):
                var elements = [Element]()
                if races.isEmpty {
                    let img = UIImage.getAssetImage(name: "No search data")
                    let empty = Element(content: BusTicketHomeView.ViewState.Placeholder(
                        title: "main_bus_error_empty".localized(in: .module),
                        subtitle: "main_bus_error_empty_desc".localized(in: .module),
                        image: img)
                    )
                    elements.append(empty)
                } else {
                    let searchItems: [BusTicketHomeView.ViewState.BusTicketData] = races.map { race in
                        let freeSeats = String.localizedStringWithFormat("main_bus_seats_free".localized(in: .module), "\(race.freeSeats)")
                        var duration = ""
                        if let strDuration = Utils.getTotalTimeString(from: race.duration) {
                            duration = strDuration
                        }
                        return .init(
                            carrier: race.carrier.name,
                            price: "\(race.price)₽",
                            seats: freeSeats,
                            fromDate: race.dispatchDate.toFormat("dd MMM"),
                            fromTime: race.dispatchDate.toFormat("HH:mm"),
                            from: race.dispatchStationName,
                            fromDetailed: race.dispatchStationName,
                            toDate: race.arrivalDate.toFormat("dd MMM"),
                            toTime: race.arrivalDate.toFormat("HH:mm"),
                            to:  race.arrivalStationName,
                            toDetailed: race.arrivalStationName,
                            duration: duration,
                            onSelect: { [weak self] in
                                self?.showDetails(race: race)
                            }
                        )
                    }
                    elements.append(contentsOf: searchItems.map { Element(content: $0) })
                }
                let resultsSection = SectionState(header: nil, footer: nil)
                let resultsSectionState = OldState(model: resultsSection, elements: elements)
                self.mainView.viewState.dataState = .loaded([resultsSectionState])
            case .error(let err):
                self.mainView.viewState.dataState = .error(err)
            }
        }
    }
}
