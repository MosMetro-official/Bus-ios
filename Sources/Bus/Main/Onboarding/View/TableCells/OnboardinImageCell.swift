//
//  OnboardinImageCell.swift
//  MosmetroNew
//
//  Created by Гусейн on 21.12.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import UIKit
import SDWebImage

protocol _OnboardinImageCell: OldCellData {
    var imageURL: String { get set }
}

extension _OnboardinImageCell {
    func cell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        tableView.register(OnboardinImageCell.nib, forCellReuseIdentifier: OnboardinImageCell.identifire)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OnboardinImageCell.identifire, for: indexPath) as? OnboardinImageCell else { return .init() }
        cell.configure(data: self)
        return cell
    }
}

class OnboardinImageCell: UITableViewCell {

    @IBOutlet var mainImageView: UIImageView!
    
    @IBOutlet private var imageViewHeigthAnchor: NSLayoutConstraint!
    
    private var imageURL: String? {
        didSet {
            if let imageURL = imageURL {
                guard let photoURL = URL(string: imageURL) else { return }
                mainImageView.sd_setImage(with: photoURL, completed: nil)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageViewHeigthAnchor.constant = UIScreen.main.bounds.width * 1.2
        self.layoutIfNeeded()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(data: _OnboardinImageCell) {
        self.imageURL = data.imageURL
    }
    
}
