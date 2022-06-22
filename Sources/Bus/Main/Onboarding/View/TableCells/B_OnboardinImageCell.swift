//
//  B_OnboardinImageCell.swift
//  MosmetroNew
//
//  Created by Гусейн on 21.12.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import UIKit
import SDWebImage

protocol _B_OnboardinImageCell : OldCellData {
    var imageURL : String { get set }
}

extension _B_OnboardinImageCell {
    
    func cell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        tableView.register(B_OnboardinImageCell.nib, forCellReuseIdentifier: B_OnboardinImageCell.identifire)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: B_OnboardinImageCell.identifire, for: indexPath) as? B_OnboardinImageCell else { return .init() }
        cell.configure(data: self)
        return cell
    }
}

class B_OnboardinImageCell : UITableViewCell {
    
    @IBOutlet public var mainImageView : UIImageView!
    
    @IBOutlet private var imageViewHeigthAnchor : NSLayoutConstraint!
    
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
    
    func configure(data: _B_OnboardinImageCell) {
        self.imageURL = data.imageURL
    }
}
