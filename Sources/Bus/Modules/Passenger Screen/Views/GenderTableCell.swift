//
//  GenderTableCell.swift
//  MosmetroNew
//
//  Created by Гусейн on 29.11.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import UIKit

protocol _GenderTableCell: OldCellData {
    var gender: Passenger.Gender { get set }
    var onGenderSelect: (Passenger.Gender) -> () { get }
}

extension _GenderTableCell {
    func cell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        tableView.register(GenderTableCell.nib, forCellReuseIdentifier: GenderTableCell.identifire)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GenderTableCell.identifire, for: indexPath) as? GenderTableCell else { return .init() }
        cell.configure(data: self)
        return cell
    }
}

class GenderTableCell: UITableViewCell {
    @IBOutlet var segmentControl: UISegmentedControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private var onGenderSelect: ((Passenger.Gender) -> ())?

    @IBAction func handleSegmentChange(_ sender: UISegmentedControl) {
        onGenderSelect?(sender.selectedSegmentIndex == 0 ? .male : .female)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.segmentControl.setTitle("main_bus_gender_male".localized(in: .module), forSegmentAt: 0)
        self.segmentControl.setTitle("main_bus_gender_female".localized(in: .module), forSegmentAt: 1)
    }
    
    private func setup() {
        let selectedTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.invertedText, NSAttributedString.Key.font: UIFont.Body_15_Bold]
        let unselectedTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.textPrimary, NSAttributedString.Key.font: UIFont.Body_15_Regular]
        segmentControl.setTitleTextAttributes(unselectedTextAttributes, for: .normal)
        segmentControl.setTitleTextAttributes(selectedTextAttributes, for: .selected)
    }
    
    func configure(data: _GenderTableCell) {
        self.segmentControl.selectedSegmentIndex = data.gender == .male ? 0 : 1
        self.onGenderSelect = data.onGenderSelect
    }
}
