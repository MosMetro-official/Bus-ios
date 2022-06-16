//
//  CountrySearch.swift
//  MosmetroNew
//
//  Created by Гусейн on 06.12.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import Fuse
import UIKit

class CountrySearchController : BaseSearchController {
    
    var countries = [Country]() {
        didSet {
            if !isSearching {
                initialState()
            }
        }
    }
    
    var regions = [BusRegion]() {
        didSet {
            if !isSearching {
                initialState()
            }
        }
    }
    
    enum SearchType {
        case countries, regions
    }
    
    var countryCode: Int = 13
    
    var searchType: SearchType = .countries {
        didSet {
            switch searchType {
            case .countries:
                self.loadCountries()
            case .regions:
                self.loadRegions()
            }
        }
    }
    
    var onCountrySelect: ((Country) -> Void)?
    var onRegionSelect: ((BusRegion) -> Void)?
    
    var isSearching = false
    
    struct SearchData: _DefaultTableViewCell {
        var title: String
        var backgroundColor: UIColor
        var onSelect: () -> ()
        var isSeparatorHidden: Bool
    }
    
    struct TitleHeader: _TitleHeaderView {
        var title: String
        var style: HeaderTitleStyle
        var backgroundColor: UIColor
        var isInsetGrouped: Bool
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainView.tableView.showLoading()
        setup()
    }
    
    private func select(_ country: Country) {
        self.onCountrySelect?(country)
        self.dismiss(animated: true, completion: nil)
    }
    
    private func select(_ region: BusRegion) {
        self.onRegionSelect?(region)
        self.dismiss(animated: true, completion: nil)
    }
}

extension CountrySearchController {
    private func loadRegions() {
        let service = BusTicketService()
        service.regions(countryID: self.countryCode, callback: { result in
            switch result {
            case .success(let regions):
                self.regions = regions
                return
            case .failure(let err):
                DispatchQueue.main.async {
                    self.mainView.tableView.removeLoading()
                    self.showMetroAlert(with: .init(style: .warning, title: err.localizedDescription, onRetry: {
                        self.loadCountries()
                    }))
                    return
                }
            }
        })
    }
    
    private func loadCountries() {
        Country.getCountries(callback: { result in
            switch result {
            case .success(let countries):
                self.countries = countries
                return
            case .failure(let err):
                DispatchQueue.main.async {
                    self.mainView.tableView.removeLoading()
                    self.showMetroAlert(with: .init(style: .warning, title: err.localizedDescription, onRetry: {
                        self.loadCountries()
                    }))
                    return
                }
            }
        })
    }
    
    private func search(by text: String) {
        let fuse = Fuse(location: 0, distance: 100, threshold: 0.2, maxPatternLength: 32, isCaseSensitive: false, tokenize: false)
        switch self.searchType {
        case .countries:
            fuse.search(text, in: self.countries, completion: { results in
                let items = results.compactMap { self.countries[safe: $0.index] }
                let countriesData: [SearchData] = items.enumerated().map { index,country in
                    let onSelect: () -> () = { [weak self] in
                        self?.select(country)
                    }
                    return SearchData(title: country.name, backgroundColor: .contentIOS, onSelect: onSelect, isSeparatorHidden: index == (items.endIndex - 1))
                }
                let elements = countriesData.map { Element(content: $0) }
                let header = TitleHeader(title: "Search results".localized(in: .module), style: .medium, backgroundColor: .clear, isInsetGrouped: true)
                let sectionState = SectionState(header: header, footer: nil)
                let searchedState = OldState(model: sectionState, elements: elements)
                DispatchQueue.main.async {
                    self.mainView.viewState = .init(sectionsState: [searchedState], onTextChange: self.mainView.viewState.onTextChange, placeholder: nil)
                }
            })
        case .regions:
            fuse.search(text, in: self.regions, completion: { results in
                let items = results.compactMap { self.regions[safe: $0.index] }
                let countriesData: [SearchData] = items.enumerated().map { index,region in
                    let onSelect: () -> () = { [weak self] in
                        self?.select(region)
                    }
                    return SearchData(title: region.name + " " + region.type, backgroundColor: .contentIOS, onSelect: onSelect, isSeparatorHidden: index == (items.endIndex - 1))
                }
                let elements = countriesData.map { Element(content: $0) }
                let header = TitleHeader(title: "Search results".localized(in: .module), style: .medium, backgroundColor: .clear, isInsetGrouped: true)
                let sectionState = SectionState(header: header, footer: nil)
                let searchedState = OldState(model: sectionState, elements: elements)
                DispatchQueue.main.async {
                    self.mainView.viewState = .init(sectionsState: [searchedState], onTextChange: self.mainView.viewState.onTextChange, placeholder: nil)
                }
            })
        }
    }
    
    private func initialState() {
        let onTextChange: (String) -> Void = { text in
            if text.isEmpty {
                self.isSearching = false
                self.initialState()
            } else {
                self.isSearching = true
                self.search(by: text)
            }
        }
        
        var searchData: [SearchData] = []
        
        switch self.searchType {
        case .countries:
            searchData = self.countries.enumerated().map { index,country in
                let onSelect: () -> () = { [weak self] in
                    self?.select(country)
                }
                return SearchData(title: country.name, backgroundColor: .contentIOS, onSelect: onSelect, isSeparatorHidden: index == (self.countries.endIndex - 1))
            }
        case .regions:
            searchData = self.regions.enumerated().map { index,region in
                let onSelect: () -> () = { [weak self] in
                    self?.select(region)
                }
                return SearchData(title: region.name + " " + region.type, backgroundColor: .contentIOS, onSelect: onSelect, isSeparatorHidden: index == (self.regions.endIndex - 1))
            }
        }
        let elements = searchData.map { Element(content: $0) }
        let header = TitleHeader(title: "Страны", style: .medium, backgroundColor: .clear, isInsetGrouped: true)
        let sectionState = SectionState(header: header, footer: nil)
        let initialState = OldState(model: sectionState, elements: elements)
        
        DispatchQueue.main.async {
            self.mainView.tableView.removeLoading()
            self.mainView.viewState = .init(sectionsState: [initialState], onTextChange: onTextChange, placeholder: nil)
        }
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
}
