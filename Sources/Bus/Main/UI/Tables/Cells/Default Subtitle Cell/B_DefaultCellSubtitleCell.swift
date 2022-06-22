//
//  B_DefaultCellSubtitleCell.swift
//  MosmetroNew
//
//  Created by Сеня Римиханов on 23.05.2020.
//  Copyright © 2020 Гусейн Римиханов. All rights reserved.
//

import UIKit

protocol _B_DefaultCellSubtitleCell: OldCellData {
    var title: String { get }
    var subtitle: String { get }
    var backgroundColor: UIColor { get }
    var isSeparatorHidden: Bool { get }
}

extension _B_DefaultCellSubtitleCell {
    func cell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        tableView.register(B_DefaultCellSubtitleCell.nib, forCellReuseIdentifier: B_DefaultCellSubtitleCell.identifire)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: B_DefaultCellSubtitleCell.identifire, for: indexPath) as? B_DefaultCellSubtitleCell else { return .init() }
        cell.configure(data: self)
        return cell
    }
}

class B_DefaultCellSubtitleCell: UITableViewCell {

    static let reuseID = "B_DefaultCellSubtitleCell"
    
    @IBOutlet var dividerView: UIView!
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var subtTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func configure(data: _B_DefaultCellSubtitleCell) {
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
