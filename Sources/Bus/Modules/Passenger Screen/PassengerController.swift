//
//  PassengerController.swift
//  MosmetroNew
//
//  Created by Гусейн on 29.11.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import Foundation
import UIKit
import FloatingPanel
import CoreML
import MMCoreNetwork
import CoreAudio

class PassengerController: BaseController {
    
    let mainView = PassengerView.loadFromNib()
    private var needToLoadPassengers = true
    
    var model: BusPaymentModel? {
        didSet {
            if model?.tickets == nil {
                firstSetup()
            } else {
                if let model = model {
                    if needToLoadPassengers {
                        Passenger.fetchSaved(availableDocs: model.raceSummary.availableDocs, callback: {
                            result in
                            switch result {
                            case .success(let passengers):
                                self.recentPassengers = passengers
                                self.needToLoadPassengers = false
                            case .failure:
                                break
                            }
                        })
                    }
                }
                makeState()
            }
        }
    }
    
    private var recentPassengers: [Passenger] = [] {
        didSet {
            makeState()
        }
    }
    
    private var inputStates = [InputView.ViewState]()
    
    var onSave: ((BusPaymentModel) -> ())?
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension PassengerController {
    
    private func createInputField(index: Int, text: String?, desc: String, placeholder: String, keyboardType: UIKeyboardType, onTextEnter: @escaping (TextEnterData) -> Void, validation: ((TextValidationData) -> Bool)? = nil) -> InputView.ViewState {
        let onNext: () -> () = {
            if let current = self.inputStates.firstIndex(where: {  $0.id == index }), let next = self.inputStates[safe: current + 1] {
                self.mainView.showInput(with: next)
            } else {
                self.mainView.hideInput()
            }
        }
        
        let onBack: () -> () = {
            if let current = self.inputStates.firstIndex(where: {  $0.id == index }), let prevous = self.inputStates[safe: current - 1] {
                self.mainView.showInput(with: prevous)
            }
        }
        var isFirst = true
        if let first = self.inputStates.first {
            isFirst = first.id == index
        }
        let passengersCount = self.model?.tickets?.count ?? 0
        
        let isLast = ((passengersCount - 1) * 10 + 7) == index
        
        let nextEndImage = UIImage.getAssetImage(name: "Done1")
        let nextImage = UIImage.getAssetImage(name: "submit")
        
        return .init(id: index,
                     desc: desc,
                     text: text,
                     placeholder: placeholder,
                     onTextEnter: onTextEnter,
                     keyboardType: keyboardType,
                     onNext: onNext,
                     onBack: onBack,
                     nextImage: isLast ? nextEndImage : nextImage,
                     backImageEnabled: !isFirst,
                     validation: validation)
    }
    
    private func passengerFieldExists(for index: Int) -> Bool {
        if let _ = self.model?.tickets?[safe: index]?.passenger {
            return true
        }
        return false
    }
    
    private func birtdayValidation(text: String, replacement: String) -> (String,Bool) {
        
        if replacement == "" {
            return (text,true)
        }
        
        var _text = text
        if _text.count == 2 || _text.count == 5 {
            _text.append(".")
        }
        
        if _text.count >= 10 {
            return (_text,false)
        }
        
        return (_text,true)
    }
    
    private func phoneValidation(text: String, replacement: String) -> (String,Bool) {
        if replacement == "" {
            if text == "+7" {
                return (text,false)
            }
            return (text,true)
        }
        
        var _text = text
        if _text.count == 2 || _text.count == 6 || _text.count == 10 || _text.count == 13 {
            _text.append(" ")
        }
        
        if _text.count >= 16 {
            return (_text,false)
        }
        
        return (_text,true)
    }
    
    private func createTableState(for passenger: Passenger, index: Int) -> [OldState] {
        var sections = [OldState]()
        let onRemove: () -> () = {
            if let _ = self.model?.tickets?[safe: index] {
                self.model?.tickets?.remove(at: index)
            }
        }
        
        let titleElement = Element(content:
                                    PassengerView.ViewState.TitleCell(
                                        onRemove: index == 0 ? nil : onRemove,
                                        title: "\("main_bus_passenger".localized(in: .module)) \(index+1)")
        )
        let sec = SectionState(header: nil, footer: nil)
        sections.append(OldState(model: sec, elements: [titleElement]))
        
        // ticket type
        guard let _model = model, let currentTicket = model?.tickets?[safe: index]?.ticket else { return [] }
        let ticketTypes: [Element] = _model.raceSummary.ticketTypes.enumerated().compactMap { (offset,ticketType) in
            let isSelected = currentTicket.code == ticketType.code
            let onSelect: () -> () = { [weak self] in
                guard let self = self else { return }
                //                AnalyticsService.reportEvent(with: "newmetro.city.buybustickets.race.passenger.tap.tickettype")
                if self.passengerFieldExists(for: index) {
                    if let _ = _model.tickets?[safe: index]?.ticket {
                        self.model?.tickets![index].ticket = ticketType
                    }
                }
            }
            
            let title = ticketType.name + " • " + "\(ticketType.price) ₽"
            let ticketSelectionData = PassengerView.ViewState.ChooseField(title: title,
                                                                          leftImage: nil,
                                                                          leftImageURL: nil,
                                                                          isSelected: isSelected,
                                                                          isHidingSeparator: offset == (_model.raceSummary.ticketTypes.endIndex - 1),
                                                                          backgroundColor: .contentIOS,
                                                                          onSelect: onSelect)
            return Element(content: ticketSelectionData)
        }
        
        let ticketTypeHeader =  PassengerView.ViewState.TitleHeader(title: "main_bus_ticket_type".localized(in: .module), style: .small, backgroundColor: .clear, isInsetGrouped: true)
        let ticketTypeSectionState = SectionState(header: ticketTypeHeader, footer: nil)
        sections.append(OldState(model: ticketTypeSectionState, elements: ticketTypes))
        
        var personalItems = [Element]()
        // name
        let onNameEnter: (TextEnterData) -> () = { data in
            if self.passengerFieldExists(for: index) {
                self.model?.tickets?[index].passenger?.name = data.text.isEmpty ? nil : data.text
            }
        }
        
        let nameState = self.createInputField(index: (index * 10) + 1,
                                              text: passenger.name,
                                              desc: "main_bus_name".localized(in: .module),
                                              placeholder: "main_bus_name_placeholder".localized(in: .module),
                                              keyboardType: .default,
                                              onTextEnter: onNameEnter)
        
        self.inputStates.append(nameState)
        
        let nameField = Element(content: PassengerView.ViewState.Field(title: passenger.name == nil ? "main_bus_name".localized(in: .module) : passenger.name!,
                                                                       backgroundColor: .contentIOS,
                                                                       isSeparatorHidden: true,
                                                                       textColor: passenger.name == nil ? .textSecondary : .textPrimary, onSelect: {
            //            AnalyticsService.reportEvent(with: "newmetro.city.buybustickets.race.passenger.tap.personaldata")
            self.mainView.showInput(with: nameState)
        }) )
        
        // surname
        let onSurnameEnter: (TextEnterData) -> () = { data in
            if self.passengerFieldExists(for: index) {
                self.model?.tickets?[index].passenger?.surname = data.text.isEmpty ? nil : data.text
            }
        }
        
        let surnameState = self.createInputField(index: (index * 10) + 2,
                                                 text: passenger.surname,
                                                 desc: "main_bus_last_name".localized(in: .module),
                                                 placeholder: "main_bus_last_name_placeholder".localized(in: .module),
                                                 keyboardType: .default,
                                                 onTextEnter: onSurnameEnter)
        
        self.inputStates.append(surnameState)
        
        let surnameField = Element(content:
                                    PassengerView.ViewState.Field(title: passenger.surname == nil ? "main_bus_last_name".localized(in: .module) : passenger.surname!,
                                                                  backgroundColor: .contentIOS,
                                                                  isSeparatorHidden: true,
                                                                  textColor: passenger.surname == nil ? .textSecondary : .textPrimary, onSelect: {
            //            AnalyticsService.reportEvent(with: "newmetro.city.buybustickets.race.passenger.tap.personaldata")
            self.mainView.showInput(with: surnameState)
        })
        )
        
        let onMiddleNameEnter: (TextEnterData) -> () = { data in
            if self.passengerFieldExists(for: index) {
                self.model?.tickets?[index].passenger?.middleName = data.text.isEmpty ? nil : data.text
            }
        }
        
        let middleNameState = self.createInputField(index: (index * 10) + 3,
                                                    text: passenger.middleName,
                                                    desc: "main_bus_middle_name".localized(in: .module),
                                                    placeholder: "main_bus_middle_name_placeholder".localized(in: .module),
                                                    keyboardType: .default,
                                                    onTextEnter: onMiddleNameEnter)
        
        self.inputStates.append(middleNameState)
        
        let onMiddleNameSelect: () -> Void = { [weak self] in
            //            AnalyticsService.reportEvent(with: "newmetro.city.buybustickets.race.passenger.tap.personaldata")
            self?.mainView.showInput(with: middleNameState)
        }
        
        let middleNameField = Element(content:
                                        PassengerView.ViewState.Field(title: passenger.middleName == nil ? "main_bus_middle_name".localized(in: .module) : passenger.middleName!,
                                                                      backgroundColor: .contentIOS,
                                                                      isSeparatorHidden: true,
                                                                      textColor: passenger.surname == nil ? .textSecondary : .textPrimary, onSelect: onMiddleNameSelect
                                                                     )
        )
        
        let personalDataHeader =  PassengerView.ViewState.TitleHeader(title: "main_bus_personal_data".localized(in: .module), style: .small, backgroundColor: .clear, isInsetGrouped: true)
        let personalDataSectionState = SectionState(header: personalDataHeader, footer: nil)
        
        personalItems.append(contentsOf: [nameField,surnameField,middleNameField])
        
        if _model.raceSummary.dataRequirments.personalDataRequired {
            let onBirthdayEnter: (TextEnterData) -> () = { data in
                if self.passengerFieldExists(for: index) {
                    self.model?.tickets?[index].passenger?.birthday = data.text.isEmpty ? nil : data.text
                }
            }
            
            let validation: (TextValidationData) -> Bool = { [weak self] data in
                guard let validationData = self?.birtdayValidation(text: data.text, replacement: data.replacementString) else { return true }
                data.textField.text = validationData.0
                return validationData.1
            }
            
            let birthdayState = self.createInputField(index: (index * 10) + 4,
                                                      text: passenger.birthday,
                                                      desc: "main_bus_birthday".localized(in: .module),
                                                      placeholder: "01.01.2000",
                                                      keyboardType: .numberPad,
                                                      onTextEnter: onBirthdayEnter,
                                                      validation: validation)
            self.inputStates.append(birthdayState)
            
            let onBirthdaySelect: () -> Void = { [weak self] in
                //                AnalyticsService.reportEvent(with: "newmetro.city.buybustickets.race.passenger.tap.personaldata")
                self?.mainView.showInput(with: birthdayState)
            }
            
            let birthdayField = Element(content:
                                            PassengerView.ViewState.Field(title: passenger.birthday == nil ? "main_bus_birthday".localized(in: .module) : passenger.birthday!,
                                                                          backgroundColor: .contentIOS,
                                                                          isSeparatorHidden: true,
                                                                          textColor: passenger.birthday == nil ? .textSecondary : .textPrimary, onSelect: onBirthdaySelect
                                                                         )
            )
            personalItems.append(birthdayField)
        }
        
        if _model.raceSummary.dataRequirments.phoneRequired {
            // phone
            let onPhoneEnter: (TextEnterData) -> () = { data in
                if self.passengerFieldExists(for: index) {
                    self.model?.tickets?[index].passenger?.phone = data.text.isEmpty ? nil : data.text
                }
            }
            
            let phoneValidation: (TextValidationData) -> Bool = { [weak self] data in
                guard let validationData = self?.phoneValidation(text: data.text, replacement: data.replacementString) else { return true }
                data.textField.text = validationData.0
                return validationData.1
            }
            
            let phoneState = self.createInputField(index: (index * 10) + 5,
                                                   text: passenger.phone == nil ? "+7" : passenger.phone!,
                                                   desc: "main_bus_phone".localized(in: .module),
                                                   placeholder: "+7 900 000 00 00",
                                                   keyboardType: .numberPad,
                                                   onTextEnter: onPhoneEnter,
                                                   validation: phoneValidation)
            
            self.inputStates.append(phoneState)
            
            let onPhoneSelect: () -> Void = { [weak self] in
                //                AnalyticsService.reportEvent(with: "newmetro.city.buybustickets.race.passenger.tap.personaldata")
                self?.mainView.showInput(with: phoneState)
            }
            
            let phoneField = Element(content:
                                        PassengerView.ViewState.Field(title: passenger.phone == nil ? "main_bus_phone".localized(in: .module) : passenger.phone!,
                                                                      backgroundColor: .contentIOS,
                                                                      isSeparatorHidden: true,
                                                                      textColor: passenger.phone == nil ? .textSecondary : .textPrimary, onSelect: onPhoneSelect
                                                                     )
            )
            
            personalItems.append(phoneField)
        }
        
        sections.append(OldState(model: personalDataSectionState, elements: personalItems))
        
        var documentItems = [Element]()
        if _model.raceSummary.dataRequirments.personalDataRequired {
            // Gender
            let genderField = Element(content: PassengerView.ViewState.Gender(gender: passenger.gender, onGenderSelect: { gender in
                //                AnalyticsService.reportEvent(with: "newmetro.city.buybustickets.race.passenger.tap.sex")
                if let _ = self.model?.tickets?[safe: index]?.passenger {
                    self.model!.tickets![index].passenger!.gender = gender
                }
            }))
            
            let genderHeader =  PassengerView.ViewState.TitleHeader(title: "main_bus_gender".localized(in: .module), style: .small, backgroundColor: .clear, isInsetGrouped: true)
            let genderSectionState = SectionState(isCollapsed: false, header: genderHeader, footer: nil)
            sections.append(OldState(model: genderSectionState, elements: [genderField]))
            
            let onCountrySelect: () -> () = {
                //                AnalyticsService.reportEvent(with: "newmetro.city.buybustickets.race.passenger.tap.citizenship")
                let countryVC = CountrySearchController()
                countryVC.modalTransitionStyle = .crossDissolve
                countryVC.modalPresentationStyle = .fullScreen
                countryVC.onCountrySelect = { country in
                    if self.passengerFieldExists(for: index) {
                        self.model?.tickets?[index].passenger?.citizenship = country
                    }
                    
                }
                self.present(countryVC, animated: true, completion: {
                    countryVC.searchType = .countries
                })
            }
            
            let countryImage = UIImage.getAssetImage(name: "parking_location")
            let countryTitle = passenger.citizenship == nil ? "main_bus_citizenship".localized(in: .module) : passenger.citizenship!.name
            let countrySelection = Element(id: 0, content: PassengerView.ViewState.SelectField(title: countryTitle, leftImage: countryImage, separator: false, onSelect: onCountrySelect, backgroundColor: .contentIOS, accesoryType: .disclosureIndicator))
            documentItems.append(countrySelection)
        }
        
        // documents
        let onDocSelect: () -> () = {
            //            AnalyticsService.reportEvent(with: "newmetro.city.buybustickets.race.passenger.tap.document")
            let docController = DocumentController()
            guard let docs = self.model?.raceSummary.availableDocs else { return }
            docController.availableDocuments = docs
            docController.selectedDocument = passenger.document
            docController.onDocSelect = { [weak self] document in
                guard let self = self else { return }
                if self.passengerFieldExists(for: index) {
                    self.model?.tickets?[index].passenger?.document = document
                }
            }
            self.present(docController, animated: true, completion: nil)
        }
        
        let docImage = UIImage.getAssetImage(name: "passport")
        let docSelection = Element(id: 0, content: PassengerView.ViewState.SelectField(title: passenger.document.name, leftImage: docImage, separator: false, onSelect: onDocSelect, backgroundColor: .contentIOS, accesoryType: .disclosureIndicator))
        
        let onSeriesEnter: (TextEnterData) -> () = { data in
            if self.passengerFieldExists(for: index) {
                self.model?.tickets?[index].passenger?.document.series = data.text.isEmpty ? nil : data.text
            }
        }
        
        let seriesState = self.createInputField(index: (index * 10) + 6,
                                                text: passenger.document.series,
                                                desc: "main_bus_series".localized(in: .module),
                                                placeholder: "0000",
                                                keyboardType: .default,
                                                onTextEnter: onSeriesEnter)
        self.inputStates.append(seriesState)
        
        let onSeriesSelect: () -> Void = { [weak self] in
            self?.mainView.showInput(with: seriesState)
        }
        
        let docSeries = passenger.document.series == nil ? "0000" : "\(passenger.document.series!)"
        let docSeriesField = Element(content:
                                        PassengerView.ViewState.Field(title: docSeries,
                                                                      backgroundColor: .contentIOS,
                                                                      isSeparatorHidden: true,
                                                                      textColor: passenger.document.series == nil ? .textSecondary : .textPrimary, onSelect: onSeriesSelect
                                                                     )
        )
        
        let onDocNumberEnter: (TextEnterData) -> () = { data in
            if self.passengerFieldExists(for: index) {
                self.model?.tickets?[index].passenger?.document.number = data.text.isEmpty ? nil : data.text
            }
        }
        
        let docNumberState = self.createInputField(index: (index * 10) + 7,
                                                   text: passenger.document.number,
                                                   desc: "main_bus_number".localized(in: .module),
                                                   placeholder: "000000",
                                                   keyboardType: .default,
                                                   onTextEnter: onDocNumberEnter)
        self.inputStates.append(docNumberState)
        
        let onNumberSelect: () -> Void = { [weak self] in
            self?.mainView.showInput(with: docNumberState)
            
        }
        
        let docNumber = passenger.document.number == nil ? "123456" : "\(passenger.document.number!)"
        let docNumberField = Element(content:
                                        PassengerView.ViewState.Field(title: docNumber,
                                                                      backgroundColor: .contentIOS,
                                                                      isSeparatorHidden: true,
                                                                      textColor: passenger.document.number == nil ? .textSecondary : .textPrimary, onSelect: onNumberSelect
                                                                     )
        )
        
        documentItems.append(contentsOf: [docSelection,docSeriesField,docNumberField])
        
        let docHeader =  PassengerView.ViewState.TitleHeader(title: "main_bus_docs".localized(in: .module), style: .small, backgroundColor: .clear, isInsetGrouped: true)
        let docSectionState = SectionState(isCollapsed: false, header: docHeader, footer: nil)
        
        sections.append(OldState(model: docSectionState, elements: documentItems))
        
        if currentTicket.ticketClass != .luggage {
            let placeHeader = PassengerView.ViewState.TitleHeader(title: "main_bus_place".localized(in: .module), style: .small, backgroundColor: .clear, isInsetGrouped: true)
            let onPlaceSelect: () -> () = {
                //                AnalyticsService.reportEvent(with: "newmetro.city.buybustickets.race.passenger.tap.seat")
                let placeController = BusPlaceController()
                guard let seats = self.model?.raceSummary.seats else { return }
                placeController.seats = seats
                placeController.onSeatSelect = { [weak self] seat in
                    guard let self = self else { return }
                    if self.passengerFieldExists(for: index) {
                        self.model!.tickets![index].passenger!.place = seat
                    }
                }
                self.present(placeController, animated: true, completion: nil)
            }
            let placeTitle = passenger.place == nil ? "Not selected".localized(in: .module) : "\("main_bus_place".localized(in: .module)) \(passenger.place!.name)"
            let placeImage = UIImage.getAssetImage(name: "Place")
            let place = Element(content:
                                    PassengerView.ViewState.SelectField(title: placeTitle,
                                                                        leftImage: placeImage,
                                                                        separator: false,
                                                                        onSelect: onPlaceSelect,
                                                                        backgroundColor: .contentIOS,
                                                                        accesoryType: .disclosureIndicator)
            )
            
            let placeSectionState = SectionState(isCollapsed: false, header: placeHeader, footer: nil)
            sections.append(OldState(model: placeSectionState, elements: [place]))
        }
        return sections
    }
    
    private func addPassenger() {
        guard let _model = model,
              let newPassenger = Passenger.dummyPassenger(availableDocuments: _model.raceSummary.availableDocs),
              var newTicket = BusTicket.dummyTicket(availableTickets: _model.raceSummary.ticketTypes) else { return }
        newTicket.passenger = newPassenger
        self.model!.tickets?.append(newTicket)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
            self.mainView.scrollToNewPassenger()
        })
    }
    
    private func firstSetup() {
        guard let _model = model,
              let newPassenger = Passenger.dummyPassenger(availableDocuments: _model.raceSummary.availableDocs),
              var newTicket = BusTicket.dummyTicket(availableTickets: _model.raceSummary.ticketTypes) else { return }
        newTicket.passenger = newPassenger
        self.model?.tickets = [newTicket]
    }
    
    private func handleAdd() {
        
    }
    
    private func handleNext() {
        
    }
    
    private func handleBack() {
        
    }
    
    private func makeState() {
        self.inputStates.removeAll()
        if let model = model {
            var finalState = [OldState]()
            if let tickets = model.tickets {
                let passengers = tickets.compactMap { $0.passenger }
                self.inputStates.removeAll()
                for (index,passenger) in passengers.enumerated() {
                    let tableState = createTableState(for: passenger, index: index)
                    finalState.append(contentsOf: tableState)
                }
            }
            let onSave: () -> () = { [weak self] in
                guard let self = self else { return }
                if let _model = self.model {
                    self.onSave?(_model)
                    if let passengers = _model.tickets?.compactMap({ $0.passenger }) {
                        Passenger.save(passengers: passengers)
                    }
                }
                self.navigationController?.popViewController(animated: true)
            }
            let onAdd: () -> () = { [weak self] in
                self?.handleAdd()
            }
            var menuItems: [PassengerView.ViewState.MenuItem] = [.init(title: "main_bus_add_passenger".localized(in: .module), image: UIImage.getAssetImage(name: "Plus"), onSelect: { self.addPassenger()  })]
            let img = UIImage.getAssetImage(name: "UserProfile")
            let recent: [PassengerView.ViewState.MenuItem] = recentPassengers.map { passenger in
                let title = createMenuTitle(for: passenger)
                let onSelect: () -> () = { [weak self] in
                    self?.handleSelect(passenger: passenger)
                }
                return .init(title: title, image: img, onSelect: onSelect)
            }
            menuItems.append(contentsOf: recent)
            self.mainView.viewState = .init(items: finalState, onSave: canSave() ? onSave : nil, onAdd: onAdd, menuItems: menuItems)
        }
    }
    
    private func createMenuTitle(for passenger: Passenger) -> String {
        var lastComponent = ""
        if let name = passenger.name?.first, let middleName = passenger.middleName?.first {
            lastComponent = "\(name). \(middleName).".capitalized
        }
        return "\(passenger.surname ?? "") \(lastComponent)"
    }
    
    private func handleSelect(passenger: Passenger) {
        if let current = model?.tickets?.first?.passenger {
            if current.name != nil || current.middleName != nil {
                guard var newTicket = BusTicket.dummyTicket(availableTickets: model!.raceSummary.ticketTypes) else { return }
                newTicket.passenger = passenger
                self.model?.tickets?.append(newTicket)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
                    self.mainView.scrollToNewPassenger()
                })
            } else {
                self.model?.tickets?[0].passenger = passenger
            }
        }
    }
    
    private func validate(dataReqs: DataRequirments, ticket: BusTicket) -> Bool {
        guard let passenger = ticket.passenger else { return false }
        var canSave = false
        switch ticket.ticket.ticketClass {
        case .full:
            if dataReqs.phoneRequired {
                canSave = passenger.phone != nil
            }
            if dataReqs.personalDataRequired {
                canSave = passenger.citizenship != nil
            }
            canSave = passenger.name != nil && passenger.surname != nil && passenger.document.number != nil && passenger.place != nil && passenger.document.series != nil
        case .luggage:
            canSave = passenger.name != nil && passenger.surname != nil && passenger.document.number != nil && passenger.document.series != nil
        }
        return canSave
    }
    
    private func canSave() -> Bool {
        var canSave = false
        if let model = model {
            if let tickets = model.tickets {
                for ticket in tickets {
                    canSave = validate(dataReqs: model.raceSummary.dataRequirments, ticket: ticket)
                }
            }
        }
        return canSave
    }
}
