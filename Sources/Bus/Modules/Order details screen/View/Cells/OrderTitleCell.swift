//
//  OrderTitleCell.swift
//  MosmetroNew
//
//  Created by Гусейн on 14.12.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import UIKit

protocol _OrderTitleCell: OldCellData {
    var title: String { get }
    var subtitle: String { get }
}

extension _OrderTitleCell {
    func cell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        tableView.register(OrderTitleCell.nib, forCellReuseIdentifier: OrderTitleCell.identifire)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OrderTitleCell.identifire, for: indexPath) as? OrderTitleCell else { return .init() }
        cell.configure(data: self)
        return cell
    }
}

class OrderTitleCell: UITableViewCell {
    
    @IBOutlet private var subtitleLabel: UILabel!
    @IBOutlet private var mainTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(data: _OrderTitleCell) {
        self.mainTitleLabel.text = data.title
        self.subtitleLabel.text = data.subtitle
    }
}
