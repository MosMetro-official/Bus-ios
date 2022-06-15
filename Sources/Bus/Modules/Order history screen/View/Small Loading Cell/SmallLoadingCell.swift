//
//  SmallLoadingCell.swift
//  MosmetroNew
//
//  Created by Гусейн on 16.12.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import UIKit

protocol _SmallLoadingCell: OldCellData {
    
}

extension _SmallLoadingCell {
    func cell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        tableView.register(SmallLoadingCell.nib, forCellReuseIdentifier: SmallLoadingCell.identifire)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SmallLoadingCell.identifire, for: indexPath) as? SmallLoadingCell else { return .init() }
        cell.congifure()
        return cell
    }
}

class SmallLoadingCell: UITableViewCell {
    @IBOutlet private var loadingIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func congifure() {
        loadingIndicator.startAnimating()
    }
}
