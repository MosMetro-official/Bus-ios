//
//  LoadingTableViewCell.swift
//  MosmetroNew
//
//  Created by Сеня Римиханов on 24.06.2020.
//  Copyright © 2020 Гусейн Римиханов. All rights reserved.
//

import UIKit

protocol _Loading: OldCellData {
    var loadingTitle: String? { get set }
}

extension _Loading {
    func cell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        tableView.register(LoadingTableViewCell.nib, forCellReuseIdentifier: LoadingTableViewCell.identifire)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LoadingTableViewCell.identifire, for: indexPath) as? LoadingTableViewCell else { return .init() }
        cell.configure(with: self)
        return cell
    }
}

class LoadingTableViewCell: UITableViewCell {
        
    @IBOutlet weak private var loadingSpinner : UIActivityIndicatorView!
    
    @IBOutlet weak private var loadingLabel : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupCell()
    }
    
    override func prepareForReuse() {
        self.loadingLabel.text = nil
        loadingSpinner.startAnimating()
    }
    
    private func setupCell() {
        if #available(iOS 13.0, *) {
            self.loadingSpinner  .style = .medium
        }
        self.loadingSpinner.startAnimating()
        self.loadingLabel.text = "Loading...".localized(in: .module)
    }
    
    public func configure(with data: _Loading) {
        self.loadingLabel.text = data.loadingTitle == nil ? "Loading...".localized(in: .module) : data.loadingTitle
    }
}
