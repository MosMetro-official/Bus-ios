//
//  B_DefaultTableViewCell.swift
//  MosmetroNew
//
//  Created by Сеня Римиханов on 23.05.2020.
//  Copyright © 2020 Гусейн Римиханов. All rights reserved.
//

import UIKit

protocol _B_DefaultTableViewCell: OldCellData {
    var title: String { get }
    var backgroundColor: UIColor { get }
    var isSeparatorHidden: Bool { get }
    var textColor: UIColor { get }
}

extension _B_DefaultTableViewCell {
    var textColor: UIColor { return .textPrimary }
    
    func cell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        tableView.register(B_DefaultTableViewCell.nib, forCellReuseIdentifier: B_DefaultTableViewCell.identifire)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: B_DefaultTableViewCell.identifire, for: indexPath) as? B_DefaultTableViewCell else { return .init() }
        cell.configure(data: self)
        return cell
    }
}

class B_DefaultTableViewCell : UITableViewCell {
    
    static let reuseID = "B_DefaultTableViewCell"
    
    @IBOutlet var dividerView: UIView!
    @IBOutlet weak var mainTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    public func setTitle(color: UIColor, font: UIFont) {
        mainTextLabel.textColor = color
        mainTextLabel.font      = font
    }

    public func configure(with text: String) {
        mainTextLabel.text = text
    }
    
    func configure(data: _B_DefaultTableViewCell) {
        self.mainTextLabel.text = data.title
        self.backgroundColor = data.backgroundColor
        self.dividerView.isHidden = data.isSeparatorHidden
        self.mainTextLabel.textColor = data.textColor
        if let accessoryView = data.accessoryView {
            self.accessoryView = accessoryView
        }        
    }
}
