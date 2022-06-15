//
//  BusDestinationSearchController.swift
//  MosmetroNew
//
//  Created by Гусейн on 16.11.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import Foundation
import UIKit
import ViewAnimator
import Fuse
import Localize_Swift

class BusDestinationSearchController: BaseSearchController {
    
    private var hasLoaded = false
    
    var isSearching = false
    
    var departureModel: DepartureSearchModel? {
        didSet {
            if !isSearching {
                self.loadDeparture(regionID: nil)
            }
            
        }
    }
    
    var arrivalModel: ArrivalSearchModel? {
        didSet {
            
            if !isSearching {
                if let from = arrivalModel?.from {
                    self.mainView.tableView.showLoading()
                    self.loadArrival(fromID: from.id)
                }
            }
        }
    }
    
    var results: [Destination] = [] {
        didSet {
            if !isSearching {
                makeState()
            }
        }
    }
    
    var onDestinationSelect: ((Any) -> Void)?
    
    struct SelectField: _DefaultRightLabel {
        var leftTitle: String
        var rightTitle: String
        var backgroundColor: UIColor
        var accesoryType: UITableViewCell.AccessoryType?
        var onSelect: () -> ()
    }
    
    struct SearchItem: _DefaultCellSubtitleCell {
        var subtitle: String
        var title: String
        var backgroundColor: UIColor
        var isSeparatorHidden: Bool
        var onSelect: () -> ()
        var accesoryType: UITableViewCell.AccessoryType?
    }
    
    struct TitleHeader: _TitleHeaderView {
        var title: String
        var style: HeaderTitleStyle
        var backgroundColor: UIColor
        var isInsetGrouped: Bool
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func loadDeparture(regionID: Int?) {
        let ticketService = BusTicketService()
        ticketService.getDeparturePoints(regionID: regionID, callback: { result in
            switch result {
            case .success(let points):
                self.results = points
                self.mainView.removeLoading()
                return
            case .failure(let err):
                DispatchQueue.main.async {
                    self.showMetroAlert(with: .init(style: .warning, title: err.errorDescription, onRetry: { [weak self] in
                        self?.loadDeparture(regionID: regionID)
                    }))
                    return
                }
            }
        })
    }
    
    private func loadArrival(fromID: Int) {
        let ticketService = BusTicketService()
        ticketService.getAvailablePoints(fromID: fromID, callback: { result in
            switch result {
            case .success(let points):
                self.mainView.removeLoading()
                self.results = points
                return
            case .failure(let err):
                DispatchQueue.main.async {
                    self.mainView.removeLoading()
                    self.showMetroAlert(with: .init(style: .warning, title: err.errorDescription, onRetry: { [weak self] in
                        self?.loadArrival(fromID: fromID)
                    }))
                    return
                }
            }
        })
    }
}

extension BusDestinationSearchController {
    
    private func showCountrySearch() {
        let controller = CountrySearchController()
        controller.modalTransitionStyle = .crossDissolve
        controller.modalPresentationStyle = .fullScreen
        controller.searchType = .countries
        controller.onCountrySelect = { [weak self] country in
            self?.departureModel?.country = country
        }
        self.present(controller, animated: true, completion: nil)
    }
    
    private func set(destination: Destination) {
        if let _ = self.departureModel {
            self.departureModel?.from = destination
            self.onDestinationSelect?(self.departureModel!)
        }
        if let _ = self.arrivalModel {
            self.arrivalModel?.to = destination
            self.onDestinationSelect?(self.arrivalModel!)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    private func showRegionSearch() {
        let controller = CountrySearchController()
        controller.modalTransitionStyle = .crossDissolve
        controller.modalPresentationStyle = .fullScreen
        controller.countryCode = self.departureModel?.country?.id ?? 13
        controller.searchType = .regions
        controller.onRegionSelect = { [weak self] region in
            self?.departureModel?.region = region
        }
        self.present(controller, animated: true, completion: nil)
    }
    
    private func setup() {
        mainView.backgroundColor = .baseIOS
        mainView.tableView.backgroundColor = .baseIOS
        mainView.tableView.register(StandartSubtitleCell.nib, forCellReuseIdentifier: StandartSubtitleCell.identifire)
        mainView.tableView.register(ImagePlaceholderTableCell.nib, forCellReuseIdentifier: ImagePlaceholderTableCell.identifire)
        mainView.tableView.estimatedRowHeight = 44
        mainView.tableView.estimatedSectionHeaderHeight = 44
        mainView.tableView.estimatedSectionFooterHeight = 44
        mainView.tableView.sectionHeaderHeight =  UITableView.automaticDimension
        mainView.tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
    }
    
    private func search(by text: String) {
        let fuse = Fuse(location: 0, distance: 100, threshold: 0.2, maxPatternLength: 32, isCaseSensitive: false, tokenize: false)
        fuse.search(text, in: self.results, completion: { results in
            let items = results.compactMap { self.results[safe: $0.index] }
            let resultsData: [SearchItem] = items.enumerated().map { index, item in
                let onSelect: () -> () = { [weak self] in
                    self?.set(destination: item)
                }
                return SearchItem(subtitle: item.region, title: item.name, backgroundColor: .contentIOS, isSeparatorHidden: index == (items.endIndex - 1), onSelect: onSelect, accesoryType: .disclosureIndicator)
            }
            let elements = resultsData.map { Element(content: $0) }
            let header = TitleHeader(title: "Search results".localized(in: .module), style: .medium, backgroundColor: .clear, isInsetGrouped: true)
            let sectionState = SectionState(header: header, footer: nil)
            let searchedState = OldState(model: sectionState, elements: elements)
            DispatchQueue.main.async {
                self.mainView.viewState = .init(sectionsState: [searchedState], onTextChange: self.mainView.viewState.onTextChange, placeholder: nil)
            }
        })
    }
    
    private func makeState() {
        let onTextChange: (String) -> Void = { text in
            if text.isEmpty {
                self.isSearching = false
                self.makeState()
            } else {
                self.isSearching = true
                self.search(by: text)
            }
        }
        
        var sections = [OldState]()
        
        let searchItemData: [SearchItem] = self.results.enumerated().map { (index,destination) in
            let onSelect: () -> () = { [weak self] in
                self?.set(destination: destination)
            }
            return .init(subtitle: destination.region, title: destination.name, backgroundColor: .contentIOS, isSeparatorHidden: index == (self.results.endIndex - 1), onSelect: onSelect, accesoryType: .disclosureIndicator)
        }
        
        let resultsSection = SectionState(header: nil, footer: nil)
        let resultsSectionState = OldState(model: resultsSection, elements: searchItemData.map { Element(content: $0) })
        sections.append(resultsSectionState)
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.mainView.viewState = .init(sectionsState: sections, onTextChange: onTextChange, placeholder: nil)
        }
    }
}
