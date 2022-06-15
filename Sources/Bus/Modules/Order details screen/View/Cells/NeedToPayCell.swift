//
//  NeedToPayCell.swift
//  MosmetroNew
//
//  Created by Гусейн on 17.12.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import UIKit

protocol _NeedToPayCell: OldCellData {
    var title: String { get }
}

extension _NeedToPayCell {
    func cell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        tableView.register(NeedToPayCell.nib, forCellReuseIdentifier: NeedToPayCell.identifire)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NeedToPayCell.identifire, for: indexPath) as? NeedToPayCell else { return .init() }
        cell.configure(data: self)
        return cell
    }
}

class NeedToPayCell: UITableViewCell {

    @IBOutlet private var mainTitleLabel: UILabel!
    @IBOutlet private var backView: UIView!
    @IBOutlet private var payButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.roundCorners(.all, radius: 16)
        payButton.roundCorners(.all, radius: 17)
        backView.layer.borderWidth = 1
        backView.layer.borderColor = UIColor.warning.cgColor
    }
    
    func configure(data: _NeedToPayCell) {
        self.mainTitleLabel.text = data.title
    }
}
