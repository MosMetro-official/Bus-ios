//
//  DefaultCellSubtitleCell.swift
//  MosmetroNew
//
//  Created by Сеня Римиханов on 23.05.2020.
//  Copyright © 2020 Гусейн Римиханов. All rights reserved.
//

import UIKit

protocol _DefaultCellSubtitleCell: OldCellData {
    var title: String { get }
    var subtitle: String { get }
    var backgroundColor: UIColor { get }
    var isSeparatorHidden: Bool { get }
}

extension _DefaultCellSubtitleCell {
    func cell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        tableView.register(DefaultCellSubtitleCell.nib, forCellReuseIdentifier: DefaultCellSubtitleCell.identifire)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DefaultCellSubtitleCell.identifire, for: indexPath) as? DefaultCellSubtitleCell else { return .init() }
        cell.configure(data: self)
        return cell
    }
}

class DefaultCellSubtitleCell: UITableViewCell {

    static let reuseID = "DefaultCellSubtitleCell"
    
    @IBOutlet var dividerView: UIView!
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var subtTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func configure(data: _DefaultCellSubtitleCell) {
        self.mainTitleLabel.text = data.title
        self.subtTitleLabel.text = data.subtitle
        self.backgroundColor = data.backgroundColor
        self.dividerView.isHidden = data.isSeparatorHidden
        if let accesory = data.accesoryType {
            self.accessoryType = accesory
        }
        
        if let accesoryView = data.accessoryView {
            self.accessoryView = accesoryView
        }
    }
}
