//
//  RideInfoTableViewCell.swift
//  MosmetroNew
//
//  Created by Гусейн on 18.05.2022.
//  Copyright © 2022 Гусейн Римиханов. All rights reserved.
//

import UIKit

protocol _RideInfoTableViewCell: OldCellData { }

extension _RideInfoTableViewCell {
    func cell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        tableView.register(RideInfoTableViewCell.nib, forCellReuseIdentifier: RideInfoTableViewCell.identifire)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RideInfoTableViewCell.identifire, for: indexPath) as? RideInfoTableViewCell else { return .init() }
        return cell
    }
}

class RideInfoTableViewCell: UITableViewCell {
    @IBOutlet private var cardView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cardView.roundCorners(.all, radius: 12)
    }
}
