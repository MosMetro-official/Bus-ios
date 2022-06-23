//
//  TicketSelectCell.swift
//  MosmetroNew
//
//  Created by Гусейн on 17.11.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import UIKit

protocol _TicketSelectCell : OldCellData {
    var image: UIImage { get set }
    var title: String { get set }
    var subtitle: String { get set }
    var subtitleColor: UIColor { get set }
    var onSelect: () -> () { get set }
}

extension _TicketSelectCell {
    
    func cell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TicketSelectCell.identifire, for: indexPath) as? TicketSelectCell else { return .init() }
        cell.configure(data: self)
        return cell
    }
}

class TicketSelectCell : UITableViewCell {
    
    private var onSelect: (() -> ())?
    
    @IBOutlet var leftImageView: UIImageView!
    
    @IBOutlet var mainTitleLabel: UILabel!
    
    @IBOutlet var changeButton: UIButton!
    
    @IBOutlet var subtitleLabel: UILabel!
    
    @IBOutlet private var buttonWidthAnchor: NSLayoutConstraint!
    
    @IBAction func handleTap(_ sender: UIButton) {
        onSelect?()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        changeButton.roundCorners(.all, radius: 15)
        changeButton.setTitle("Change".localized(in: Bus.shared.bundle), for: .normal)
    }
    
    public func configure(data: _TicketSelectCell) {
        self.leftImageView.image = data.image
        self.mainTitleLabel.text = data.title
        self.subtitleLabel.text = data.subtitle
        self.subtitleLabel.textColor = data.subtitleColor
        self.onSelect = data.onSelect
        let buttonTextSize = "Change".localized(in: Bus.shared.bundle).width(withConstrainedHeight: 30, font: .Body_15_Medium)
        self.buttonWidthAnchor.constant = buttonTextSize + 16
        self.layoutIfNeeded()
    }
}
