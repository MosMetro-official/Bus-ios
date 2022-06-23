//
//  Ext+UITableViewCell.swift
//  
//
//  Created by Слава Платонов on 09.03.2022.
//

import UIKit

extension UITableViewCell {
    
    static var nib  : UINib {
        return UINib(nibName: identifire, bundle: Bus.shared.bundle)
    }
    
    static var identifire : String {
        return String(describing: self)
    }
}

extension UICollectionViewCell {
    
    static var nib  : UINib {
        return UINib(nibName: identifire, bundle: Bus.shared.bundle)
    }
    
    static var identifire : String {
        return String(describing: self)
    }
}

extension UITableViewHeaderFooterView {
    
    static var nib  : UINib {
        return UINib(nibName: identifire, bundle: Bus.shared.bundle)
    }
    
    static var identifire : String {
        return String(describing: self)
    }
}
