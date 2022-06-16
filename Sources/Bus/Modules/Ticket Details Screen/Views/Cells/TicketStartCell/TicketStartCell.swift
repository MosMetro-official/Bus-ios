//
//  TicketStartCell.swift
//  MosmetroNew
//
//  Created by Гусейн on 17.11.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import UIKit

protocol _TicketStartCell: OldCellData {
    var title : String { get set }
    var subtitle : String { get set }
}

extension _TicketStartCell {
    
    func cell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        tableView.register(TicketStartCell.nib, forCellReuseIdentifier: TicketStartCell.identifire)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TicketStartCell.identifire, for: indexPath) as? TicketStartCell else { return .init() }
        cell.configure(data: self)
        return cell
    }
}

class TicketStartCell : UITableViewCell {

    @IBOutlet private var subtitleLabel: UILabel!
    
    @IBOutlet private var mainTitleLabel: UILabel!
    
    public func configure(data: _TicketStartCell) {
        self.mainTitleLabel.text = data.title
        self.subtitleLabel.text = data.subtitle
    }
}
