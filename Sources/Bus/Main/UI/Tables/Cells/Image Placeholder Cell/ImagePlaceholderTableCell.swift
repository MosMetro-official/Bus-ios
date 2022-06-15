//
//  ImagePlaceholderTableCell.swift
//  MosmetroNew
//
//  Created by Сеня Римиханов on 09.09.2020.
//  Copyright © 2020 Гусейн Римиханов. All rights reserved.
//

import UIKit

protocol _ImagePlaceholderTableCell: OldCellData {
    var title: String { get set }
    var subtitle: String { get set }
    var image: UIImage { get set }
}

extension _ImagePlaceholderTableCell {
    func cell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        tableView.register(ImagePlaceholderTableCell.nib, forCellReuseIdentifier: ImagePlaceholderTableCell.identifire)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ImagePlaceholderTableCell.identifire, for: indexPath) as? ImagePlaceholderTableCell else { return .init() }
        cell.configure(data: self)
        return cell
    }
}

class ImagePlaceholderTableCell: UITableViewCell {

    static let reuseID = "ImagePlaceholderTableCell"

    @IBOutlet weak var placeholderSubtitleLabel : UILabel!
    @IBOutlet weak var placeholderTitleLabel    : UILabel!
    @IBOutlet weak var placeholderImageView     : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    public func configure(data: _ImagePlaceholderTableCell) {
        self.placeholderTitleLabel.text = data.title
        self.placeholderSubtitleLabel.text = data.subtitle
        self.placeholderImageView.image = data.image
    }
}
