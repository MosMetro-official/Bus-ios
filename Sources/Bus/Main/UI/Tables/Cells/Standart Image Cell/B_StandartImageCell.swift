//
//  DefaultImageCellTableViewCell.swift
//  MosmetroNew
//
//  Created by Сеня Римиханов on 01.06.2020.
//  Copyright © 2020 Гусейн Римиханов. All rights reserved.
//

import UIKit

protocol _StandartImage: OldCellData {
    var title     : String   { get set }
    var leftImage : UIImage? { get set }
    var separator : Bool     { get set }
    var backgroundColor: UIColor? { get }
}

extension _StandartImage {
    var backgroundColor: UIColor? { return nil }
    
    func cell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: B_StandartImageCell.identifire, for: indexPath) as? B_StandartImageCell else { return .init() }
        cell.configure(with: self)
        return cell
    }
    
}

class B_StandartImageCell : UITableViewCell {
        
    @IBOutlet weak private var separator : UIView!
    @IBOutlet weak private var title     : UILabel!
    @IBOutlet weak private var leftImage : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        isUserInteractionEnabled = true
    }
    
    override func prepareForReuse() {
        self.title.text          = nil
        self.title.textColor     = nil
        self.leftImage.image     = nil
        self.leftImage.tintColor = nil
    }
    
    public func configure(with data: _StandartImage, imageColor: UIColor = .textPrimary, boldText: Bool = false, textColor: UIColor = .textPrimary) {
        self.title.text          = data.title
        self.leftImage.image     = data.leftImage
        self.separator.isHidden  = !data.separator
        self.leftImage.tintColor = imageColor
        self.title.textColor = textColor
        if boldText {
            self.title.font      = .BODY_S_BOLD
        }
        if let accesory = data.accesoryType {
            self.accessoryType = accesory
        }
        
        if let bgColor = data.backgroundColor  {
            self.backgroundColor = bgColor
        }
        
        self.leftImage.tintColor = data.tintColor
        
    }
    
}
