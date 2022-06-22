//
//  TicketDetailCell.swift
//  MosmetroNew
//
//  Created by Гусейн on 10.12.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import UIKit

protocol _TicketDetailCell: OldCellData {
    var number: String { get }
    var price: String { get }
    var passenger: String { get }
    var place: String { get }
    var onRefund: () -> () { get }
    var onDownload: () -> () { get }
    var downloadTitle: String { get }
    var onRefundDetails: () -> () { get }
    var status: BusOrder.BookingStatus { get }
}

extension _TicketDetailCell {
    func cell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        tableView.register(TicketDetailCell.nib, forCellReuseIdentifier: TicketDetailCell.identifire)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TicketDetailCell.identifire, for: indexPath) as? TicketDetailCell else { return .init() }
        cell.configure(data: self)
        return cell
    }
}

class TicketDetailCell: UITableViewCell {

    @IBOutlet private var ticketViewToStatusView: NSLayoutConstraint!
    @IBOutlet private var ticketViewToSuperview: NSLayoutConstraint!
    
    @IBOutlet private var statusLabel: UILabel!
    @IBOutlet private var statusView: UIView!
    @IBOutlet private var ticketView: UIView!
    
    @IBOutlet private var needToPayLabel: UILabel!
    @IBOutlet private var refundDetailsButton: B_MKButton!
    @IBOutlet private var docButton: B_MKButton!
    @IBOutlet private var returnButton: B_MKButton!
    
    @IBOutlet private var rightRoundView: UIView!
    @IBOutlet private var leftRoundView: UIView!
    
    @IBOutlet private var ticketNumberLabel: UILabel!
    @IBOutlet private var ticketPriceLabel: UILabel!
    @IBOutlet private var placelabel: UILabel!
    @IBOutlet private var separatorView: UIView!
    
    @IBOutlet private var passengerDataLabel: UILabel!
    private var onRefund: (() -> ())?
    private var onDownload: (() -> ())?
    private var onRefundDetails: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
   
    @IBAction func handleRefund(_ sender: UIButton) {
        self.onRefund?()
    }
    
    @IBAction func handleDownload(_ sender: Any) {
        self.onDownload?()
    }
    
    @IBAction func handleRefundDetails(_ sender: Any) {
        self.onRefundDetails?()
    }
    
    private func setup() {
        ticketView.roundCorners(.all, radius: 12)
        docButton.roundCorners(.all, radius: 8)
        returnButton.layer.borderWidth = 1
        returnButton.layer.borderColor = UIColor.metroRed.cgColor
        refundDetailsButton.roundCorners(.all, radius: 8)
        returnButton.roundCorners(.all, radius: 8)
        leftRoundView.roundCorners(.all, radius: 12)
        rightRoundView.roundCorners(.all, radius: 12)
        statusView.roundCorners(.top, radius: 12)
        drawDottedLine(start: CGPoint(x: 12, y: 12), end: CGPoint(x: (UIScreen.main.bounds.width - 32 - 12), y: 12), view: separatorView)
    }
    
    private func handleStatusView(status: BusOrder.BookingStatus) {
        switch status {
        case .created, .booked, .error, .fullyReturned, .cancelled, .partiallyReturned, .partiallyCancelled:
            self.statusLabel.text = status.text()
            self.statusLabel.textColor = status.ticketTextColor()
            self.ticketViewToSuperview.priority = .defaultLow
            self.ticketViewToStatusView.priority = .defaultHigh
            self.statusView.isHidden = false
        case .paid:
            self.ticketViewToSuperview.priority = .defaultHigh
            self.ticketViewToStatusView.priority = .defaultLow
            self.statusView.isHidden = true
        }
    }
    
    private func handleButtons(status: BusOrder.BookingStatus) {
        switch status {
        case .error, .fullyReturned, .cancelled, .partiallyReturned, .partiallyCancelled:
            self.docButton.isHidden = false
            self.returnButton.isHidden = true
            self.refundDetailsButton.isHidden = false
            self.needToPayLabel.isHidden = true
        case .booked, .created:
            self.docButton.isHidden = true
            self.returnButton.isHidden = true
            self.refundDetailsButton.isHidden = true
            self.needToPayLabel.isHidden = false
        case .paid:
            self.docButton.isHidden = false
            self.returnButton.isHidden = false
            self.refundDetailsButton.isHidden = true
            self.needToPayLabel.isHidden = true
        }
    }
    
    public func configure(data: _TicketDetailCell) {
        self.ticketNumberLabel.text = data.number
        self.ticketPriceLabel.text = data.price
        self.passengerDataLabel.text  = data.passenger
        self.placelabel.text = data.place
        self.docButton.setTitle(data.downloadTitle, for: .normal)
        self.onDownload = data.onDownload
        self.onRefund = data.onRefund
        self.onRefundDetails = data.onRefundDetails
        self.handleStatusView(status: data.status)
        self.handleButtons(status: data.status)
        
    }
    
    func drawDottedLine(start p0: CGPoint, end p1: CGPoint, view: UIView) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.textSecondary.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = [7, 3] // 7 is the length of dash, 3 is length of the gap.

        let path = CGMutablePath()
        path.addLines(between: [p0, p1])
        shapeLayer.path = path
        view.layer.addSublayer(shapeLayer)
    }
}
