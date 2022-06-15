//
//  BusPlaceController.swift
//  MosmetroNew
//
//  Created by Гусейн on 03.12.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import UIKit

class BusPlaceController: BaseController {
    
    let mainView = BusPlaceView.loadFromNib()
    
    var seats: [BusSeat] = [] {
        didSet {
            makeState()
        }
    }
    
    var onSeatSelect: ((BusSeat) -> ())?
    
    override func loadView() {
        super.loadView()
        self.view = mainView
        mainView.backgroundColor = .contentIOS
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .contentIOS
    }
}

extension BusPlaceController {
    
    private func makeState() {
        let items: [Element] = seats.enumerated().map { (index,seat) in
            let onSelect: () -> () = { [weak self] in
                guard let self = self else { return }
                var selectedSeat = seat
                selectedSeat.isSelected = true
                self.onSeatSelect?(selectedSeat)
                self.dismiss(animated: true, completion: nil)
            }
            let item = BusPlaceView.ViewState.Seat(text: seat.name, isSelected: seat.isSelected, isUnvailable: false, onSelect: onSelect)
            return Element(content: item)
        }
        
        let sectionState = SectionState(id: 0, header: nil, footer: nil)
        let collectionState = OldState(model: sectionState, elements: items)
        self.mainView.viewState = .init(title: "Выберите место", subtitle: "Схема может не совпадать", collectionState: [collectionState])
    }
}
