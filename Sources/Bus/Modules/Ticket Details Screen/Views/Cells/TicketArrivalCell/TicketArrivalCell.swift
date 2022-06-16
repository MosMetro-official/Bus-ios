//
//  TicketArrivalCell.swift
//  MosmetroNew
//
//  Created by Гусейн on 09.12.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import UIKit

protocol _TicketArrivalCell: OldCellData {
    var title: String { get }
    var subtitle: String { get }
}

extension _TicketArrivalCell {
    func cell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        tableView.register(TicketArrivalCell.nib, forCellReuseIdentifier: TicketArrivalCell.identifire)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TicketArrivalCell.identifire, for: indexPath) as? TicketArrivalCell else { return .init() }
        cell.configure(data: self)
        return cell
    }
}

class TicketArrivalCell : UITableViewCell {

    @IBOutlet private var subtitleLabel: UILabel!
    
    @IBOutlet private var mainTitleLabel: UILabel!
    
    func configure(data: _TicketArrivalCell) {
        self.mainTitleLabel.text = data.title
        self.subtitleLabel.text = data.subtitle
    }
}
