//
//  B_StandartSubtitleCell.swift
//  MetroTest
//
//  Created by Сеня Римиханов on 15.12.2019.
//  Copyright © 2019 Гусейн Римиханов. All rights reserved.
//

import UIKit
import SDWebImage

protocol _StandartSubtitle: OldCellData {
    var image    : UIImage? { get set }
    var imageUrl : String?  { get set }
    var title    : String   { get set }
    var descr    : String   { get set }
    var backgroundColor: UIColor? { get }
    var isSeparatorHidden: Bool { get }
}

extension _StandartSubtitle {
    var backgroundColor: UIColor? { return nil }
    var isSeparatorHidden: Bool { return true }
    
    func cell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        tableView.register(B_StandartSubtitleCell.nib, forCellReuseIdentifier: B_StandartSubtitleCell.identifire)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: B_StandartSubtitleCell.identifire, for: indexPath) as? B_StandartSubtitleCell else { return .init() }
        cell.configure(with: self)
        return cell
    }
}

class B_StandartSubtitleCell : UITableViewCell {
    
    @IBOutlet weak private var leftImage : UIImageView!
    @IBOutlet weak private var title     : UILabel!
    @IBOutlet weak private var secondary : UILabel!
    @IBOutlet weak private var separator : UIView!
    
    private var imageURL: String? {
        didSet {
            guard let urlStr = self.imageURL,
                let photoURL = URL(string: urlStr) else {
                self.leftImage.backgroundColor = .contentIOS
                self.leftImage.image = UIImage.getAssetImage(name: "placholder_image")
                return
            }
            leftImage.sd_setImage(with: photoURL, placeholderImage: nil, options: [.scaleDownLargeImages]) { (image, error, cacheType, imageUrl) in
                if imageUrl != URL(string: urlStr),
                   error    != nil,
                   image    == nil {
                    self.leftImage.image = UIImage.getAssetImage(name: "placholder_image")
                    self.leftImage.backgroundColor = .contentIOS
                }
            }
        }
    }
    
    override func awakeFromNib() {
        self.separator.roundCorners(.all, radius: 0.5)
    }
    
    override func prepareForReuse() {
        self.title.text =  nil
        self.secondary.text = nil
        self.leftImage.image = nil
    }
    
    public func configure(with data: _StandartSubtitle, imageColor: UIColor = .textPrimary, restorise: Bool = false, corners: CGFloat = 0) {
        self.leftImage.roundCorners(.all, radius: corners)
        if let urlStr = data.imageUrl {
            self.imageURL = urlStr
        }
        if let image = data.image {
            self.leftImage.image = image
        }
        self.title.text = data.title
        self.secondary.text = data.descr
        if restorise {
            layer.shouldRasterize = true
            layer.rasterizationScale = UIScreen.main.scale
        }
        
        self.separator.isHidden = data.isSeparatorHidden
        
        if let accesory = data.accesoryType {
            self.accessoryType = accesory
        }
        
        if let bgColor = data.backgroundColor {
            self.backgroundColor = bgColor
        }
        self.leftImage.tintColor = data.tintColor
    }
    
    public func paymentSetup() {
        backgroundColor = .buttonTertiary
        accessoryType   = .disclosureIndicator
        roundCorners(.all, radius: 10)
    }
}
