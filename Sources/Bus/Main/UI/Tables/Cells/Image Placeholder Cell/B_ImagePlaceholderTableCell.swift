//
//  B_ImagePlaceholderTableCell.swift
//  MosmetroNew
//
//  Created by Сеня Римиханов on 09.09.2020.
//  Copyright © 2020 Гусейн Римиханов. All rights reserved.
//

import UIKit

protocol _B_ImagePlaceholderTableCell: OldCellData {
    var title: String { get set }
    var subtitle: String { get set }
    var image: UIImage { get set }
}

extension _B_ImagePlaceholderTableCell {
    func cell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        tableView.register(B_ImagePlaceholderTableCell.nib, forCellReuseIdentifier: B_ImagePlaceholderTableCell.identifire)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: B_ImagePlaceholderTableCell.identifire, for: indexPath) as? B_ImagePlaceholderTableCell else { return .init() }
        cell.configure(data: self)
        return cell
    }
}

class B_ImagePlaceholderTableCell : UITableViewCell {

    static let reuseID = "B_ImagePlaceholderTableCell"

    @IBOutlet weak var placeholderSubtitleLabel : UILabel!
    @IBOutlet weak var placeholderTitleLabel    : UILabel!
    @IBOutlet weak var placeholderImageView     : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    public func configure(data: _B_ImagePlaceholderTableCell) {
        self.placeholderTitleLabel.text = data.title
        self.placeholderSubtitleLabel.text = data.subtitle
        self.placeholderImageView.image = data.image
    }
}
