//
//  PassengerView.swift
//  MosmetroNew
//
//  Created by Гусейн on 29.11.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import UIKit

class PassengerView: UIView {
    
    struct ViewState {
        var items: [OldState]
        var onSave: (() -> ())?
        var onAdd: () -> ()
        var menuItems: [MenuItem]
        
        struct MenuItem {
            let title: String
            let image: UIImage
            let onSelect: () -> ()
        }
        
        struct TitleHeader: _TitleHeaderView {
            var title: String
            var style: HeaderTitleStyle
            var backgroundColor: UIColor
            var isInsetGrouped: Bool
        }
        
        struct TitleCell: _PassengerNumberCell {
            var onRemove: (() -> ())?
            var title: String
        }
        
        struct SelectField: _StandartImage {
            var title: String
            var leftImage: UIImage?
            var separator: Bool
            var onSelect: () -> ()
            var backgroundColor: UIColor?
            var accesoryType: UITableViewCell.AccessoryType?
        }
        
        struct ChooseField: _DefaultSelectionCell {
            var title: String
            var leftImage: UIImage?
            var leftImageURL: String?
            var isSelected: Bool
            var isHidingSeparator: Bool
            var backgroundColor: UIColor
            var onSelect: () -> ()
        }
        
        struct Field: _DefaultTableViewCell {
            var title: String
            var backgroundColor: UIColor
            var isSeparatorHidden: Bool
            var textColor: UIColor
            var onSelect: () -> ()
        }
        
        struct Gender: _GenderTableCell {
            var gender: Passenger.Gender
            var onGenderSelect: (Passenger.Gender) -> ()
        }
        
        static let initial = ViewState.init(items: [], onSave: nil, onAdd: {}, menuItems: [])
    }
    
    public var viewState: ViewState = .initial {
        didSet {
            render()
        }
    }
    
    @IBOutlet weak var saveButton: MKButton!
    
    @IBOutlet weak var buttonsEffectView: UIVisualEffectView!
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet var tableView: OldBaseTableView!
    
    @IBOutlet weak var buttonsEffectViewHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    @IBAction func handleSave(_ sender: MKButton) {
        viewState.onSave?()
    }
    
    @IBAction func handleAdd(_ sender: UIButton) {
        
    }
}

extension PassengerView {
    
    func scrollToNewPassenger() {
        if let sectionIndex = viewState.items.lastIndex(where: { item in
            return item.elements.contains(where: { $0.content is ViewState.TitleCell })
        }) {
            guard let section = viewState.items[safe: sectionIndex] else { return }
            if let rowIndex = section.elements.firstIndex(where: { $0.content is ViewState.TitleCell }) {
                self.tableView.scrollToRow(at: IndexPath(row: rowIndex, section: sectionIndex), at: .middle, animated: true)
            }
        }
    }
    
    private func setup() {
        addButton.roundCorners(.all, radius: 8)
        saveButton.roundCorners(.all, radius: 8)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.buttonsEffectViewHeight.constant = self.safeAreaInsets.bottom + 68
            self.layoutIfNeeded()
            self.tableView.contentInset  = UIEdgeInsets(top: 16, left: 0, bottom: self.safeAreaInsets.bottom + 76, right: 0)
        })
    }
    
    private func render() {
        DispatchQueue.main.async {
                let items: [UIAction] = self.viewState.menuItems.map { menuItem in
                    return UIAction(title: menuItem.title, image: menuItem.image, handler: { _ in
                        menuItem.onSelect()
                    })
                }
            let menu = UIMenu(title: "Passengers".localized(in: .module), image: nil, identifier: nil, options: [], children: items)
                if #available(iOS 14.0, *) {
                    self.addButton.menu = menu
                    self.addButton.showsMenuAsPrimaryAction = true
                }
            self.saveButton.isEnabled = self.viewState.onSave == nil ? false : true
            self.tableView.shouldInterrupt = true
            self.tableView.viewStateInput = self.viewState.items
        }
    }
}
