//
//  OrderHistoryCell.swift
//  MosmetroNew
//
//  Created by Гусейн on 13.12.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import UIKit

protocol _OrderHistoryCell: OldCellData {
    var title: String { get }
    var subtitle: String { get }
}

extension _OrderHistoryCell {
    func cell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        tableView.register(OrderHistoryCell.nib, forCellReuseIdentifier: OrderHistoryCell.identifire)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OrderHistoryCell.identifire, for: indexPath) as? OrderHistoryCell else { return .init() }
        cell.configure(data: self)
        return cell
    }
}

class OrderHistoryCell: UITableViewCell {

    @IBOutlet private var backView: UIView!
    @IBOutlet private var descLabel: UILabel!
    @IBOutlet private var routeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.roundCorners(.all, radius: 16)
    }
    
    func configure(data: _OrderHistoryCell) {
        self.routeLabel.text = data.title
        self.descLabel.text = data.subtitle
    }
}
