//
//  DefaultSelectionCell.swift
//  MosmetroNew
//
//  Created by Сеня Римиханов on 07.12.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import UIKit
import SDWebImage

protocol _DefaultSelectionCell: OldCellData {
    var title: String { get set }
    var leftImage: UIImage? { get }
    var leftImageURL: String? { get }
    var isSelected: Bool { get set }
    var selectedTintColor: UIColor { get }
    var isHidingSeparator: Bool { get set }
    var backgroundColor: UIColor { get }
}

extension _DefaultSelectionCell {
    
    var selectedTintColor: UIColor { return .main }
    
    func cell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        tableView.register(DefaultSelectionCell.nib, forCellReuseIdentifier: DefaultSelectionCell.identifire)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DefaultSelectionCell.identifire, for: indexPath) as? DefaultSelectionCell else { return .init() }
        cell.configure(data: self)
        return cell
    }
}

class DefaultSelectionCell: UITableViewCell {
    
    @IBOutlet var dividerToSuperViewAnchor: NSLayoutConstraint!
    @IBOutlet var dividerToImageViewAnchor: NSLayoutConstraint!
    
    @IBOutlet private var titleToImageViewAnchor: NSLayoutConstraint!
    
    @IBOutlet private var titleToSuperViewAnchor: NSLayoutConstraint!
    
    @IBOutlet private weak var leftImageView: UIImageView!
    @IBOutlet private weak var mainTitleLabel: UILabel!
    
    @IBOutlet private weak var selectorImageView: UIImageView!
    
    @IBOutlet private weak var divider: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    private var imageURL: String? {
        didSet {
            if let imageURL = imageURL {
                guard let photoURL = URL(string: imageURL) else { return }
                leftImageView.sd_setImage(with: photoURL, completed: nil)
            }
        }
    }
    
    func configure(data: _DefaultSelectionCell) {
        self.mainTitleLabel.text = data.title
        if let image = data.leftImage {
            self.leftImageView.image = image
            self.dividerToImageViewAnchor.priority = .defaultHigh
            self.dividerToSuperViewAnchor.priority = .defaultLow
            self.titleToImageViewAnchor.priority  = .defaultHigh
            self.titleToSuperViewAnchor.priority = .defaultLow
        } else if let _imageUrl = data.leftImageURL {
            self.imageURL = _imageUrl
            self.dividerToImageViewAnchor.priority = .defaultHigh
            self.dividerToSuperViewAnchor.priority = .defaultLow
            self.titleToImageViewAnchor.priority  = .defaultHigh
            self.titleToSuperViewAnchor.priority = .defaultLow
        } else {
            self.dividerToImageViewAnchor.priority = .defaultLow
            self.dividerToSuperViewAnchor.priority = .defaultHigh
            self.titleToImageViewAnchor.priority  = .defaultLow
            self.titleToSuperViewAnchor.priority = .defaultHigh
        }
        
        self.selectorImageView.tintColor = data.isSelected ? data.selectedTintColor : .iconTertiary
        self.selectorImageView.image = data.isSelected ? UIImage.getAssetImage(name: "Selector_on") : UIImage.getAssetImage(name: "Selector_off")
        self.divider.isHidden = data.isHidingSeparator
        self.backgroundColor = data.backgroundColor
        
    }
}
