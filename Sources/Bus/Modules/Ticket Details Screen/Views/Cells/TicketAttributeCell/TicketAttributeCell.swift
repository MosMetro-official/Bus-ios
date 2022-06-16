//
//  TicketAttributeCell.swift
//  MosmetroNew
//
//  Created by Гусейн on 09.12.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import UIKit

protocol _TicketAttributeCell: OldCellData {
    var image : UIImage { get }
    var name : String { get }
    var value : String { get }
}

extension _TicketAttributeCell {
    
    func cell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        tableView.register(TicketAttributeCell.nib, forCellReuseIdentifier: TicketAttributeCell.identifire)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TicketAttributeCell.identifire, for: indexPath) as? TicketAttributeCell else { return .init() }
        cell.configure(data: self)
        return cell
    }
}

class TicketAttributeCell : UITableViewCell {
    
    @IBOutlet private var attributeImage: UIImageView!
    
    @IBOutlet private var nameLabel: UILabel!
    
    @IBOutlet private var valueLabel: UILabel!
    
    @IBOutlet weak var attributedView: UIView!
    
    func configure(data: _TicketAttributeCell) {
        self.attributedView.layer.cornerRadius = self.attributedView.frame.height / 2
        self.attributeImage.image = data.image
        self.nameLabel.text = data.name
        self.valueLabel.text = data.value
    }
}
