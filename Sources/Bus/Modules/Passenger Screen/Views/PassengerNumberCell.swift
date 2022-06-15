//
//  PassengerNumberCell.swift
//  MosmetroNew
//
//  Created by Гусейн on 06.12.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import UIKit

protocol _PassengerNumberCell: OldCellData {
    var title: String { get }
    var onRemove: (() -> ())? { get }
    
}

extension _PassengerNumberCell {
    func cell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        tableView.register(PassengerNumberCell.nib, forCellReuseIdentifier: PassengerNumberCell.identifire)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PassengerNumberCell.identifire, for: indexPath) as? PassengerNumberCell else { return .init() }
        cell.configure(data: self)
        return cell
    }
}

class PassengerNumberCell: UITableViewCell {
    
    @IBOutlet var removeButton: UIButton!
    @IBOutlet var mainTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
  
    }
    
    private var onRemove: (() -> ())?

    @IBAction func handleRemove(_ sender: UIButton) {
        onRemove?()
    }
    
    public func configure(data: _PassengerNumberCell) {
        self.mainTitleLabel.text = data.title
        self.onRemove = data.onRemove
        self.removeButton.isHidden = data.onRemove == nil ? true : false
    }
}
