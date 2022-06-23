//
//  B_DefaultRightLabelCell.swift
//  MosmetroNew
//
//  Created by Сеня Римиханов on 15.07.2020.
//  Copyright © 2020 Гусейн Римиханов. All rights reserved.
//

import UIKit

protocol _DefaultRightLabel: OldCellData {
    
    var leftTitle  : String   { get set }
    var rightTitle : String   { get set }
    var backgroundColor: UIColor { get }
}

extension _DefaultRightLabel {
    func cell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        tableView.register(B_DefaultRightLabelCell.nib, forCellReuseIdentifier: B_DefaultRightLabelCell.identifire)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: B_DefaultRightLabelCell.identifire, for: indexPath) as? B_DefaultRightLabelCell else { return .init() }
        cell.configure(with: self)
        return cell
    }
}

class B_DefaultRightLabelCell : UITableViewCell {
    
    static let reuseID = "B_DefaultRightLabelCell"
    
    private var onTap: (()->())?
    
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }
    
    public func configure(with data: _DefaultRightLabel) {
        mainTitleLabel.text = data.leftTitle
        rightLabel.text     = data.rightTitle
        self.backgroundColor = data.backgroundColor
        self.accessoryType = data.accesoryType ?? .none
    }
    
    public func parkingConfigure(with data: _DefaultRightLabel) {
        mainTitleLabel.text = data.leftTitle.localized(in: Bus.shared.bundle)
        rightLabel.text     = getNumberParking(from: data.rightTitle)?.localized(in: Bus.shared.bundle)
    }
    
    private func getNumberParking(from text: String) -> String? {
        if let index = text.firstIndex(where: {
            $0 == "№"
        }) {
            let nextIndex = text.index(after: index)
            let subString = text[nextIndex...]
            return String(subString)
        }
        return text
    }
}
