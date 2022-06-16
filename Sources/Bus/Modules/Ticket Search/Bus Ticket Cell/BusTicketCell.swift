//
//  BusTicketCell.swift
//  MosmetroNew
//
//  Created by Гусейн on 17.11.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import UIKit

protocol _BusTicketCell: OldCellData {
    var price : String { get set }
    var seats : String { get set }
    var carrier : String { get set }
    var fromDate : String { get set }
    var fromTime : String { get set }
    var from : String { get set }
    var fromDetailed : String { get set }
    var toDate : String { get set }
    var toTime : String { get set }
    var to : String { get set }
    var toDetailed : String { get set }
    var duration : String { get set }
}

extension _BusTicketCell {
    
    func cell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BusTicketCell.identifire, for: indexPath) as? BusTicketCell else { return .init() }
        cell.configure(data: self)
        return cell
    }
}

class BusTicketCell: UITableViewCell {
    
    @IBOutlet private weak var backView: UIView!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var seatsLabel: UILabel!
    @IBOutlet private weak var driverLabel: UILabel!
    @IBOutlet private weak var driverView: UIView!
    
    /// from
    @IBOutlet private weak var fromTimeLabel: UILabel!
    @IBOutlet private weak var fromDateLabel: UILabel!
    @IBOutlet private weak var fromLabel: UILabel!
    @IBOutlet private weak var fromDescLabel: UILabel!
    
    /// duration
    @IBOutlet private weak var durationLabel: UILabel!
    
    /// to
    @IBOutlet private weak var toTimeLabel: UILabel!
    @IBOutlet private weak var toDateLabel: UILabel!
    
    @IBOutlet private weak var toDescLabel: UILabel!
    @IBOutlet private weak var toLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backView.roundCorners(.all, radius: 10)
        self.driverView.roundCorners(.all, radius: 8)
    }
    
    public func configure(data: _BusTicketCell) {
        self.priceLabel.text = data.price
        self.seatsLabel.text = data.seats
        self.fromLabel.text = data.from
        self.driverLabel.text = data.carrier
        self.fromDescLabel.text = data.fromDetailed
        self.fromTimeLabel.text = data.fromTime
        self.fromDateLabel.text = data.fromDate
        self.toLabel.text = data.to
        self.toDescLabel.text = data.toDetailed
        self.toTimeLabel.text = data.toTime
        self.toDateLabel.text = data.toDate
        self.durationLabel.text = data.duration
    }
}
