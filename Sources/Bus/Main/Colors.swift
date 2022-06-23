//
//  ColorConstants.swift
//  MosmetroNew
//
//  Created by Владимир Камнев on 09.06.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import UIKit

extension UIColor {
    
    @available(*, deprecated, message: "Use 'main' color")
    public class var mainColor: UIColor {
        return UIColor(named: "main", in: Bus.shared.bundle, compatibleWith: nil) ?? UIColor.red
    }
    
    @available(*, deprecated, message: "Use 'baseIOS' color")
    public class var MKBase: UIColor {
        return UIColor(named: "Base", in: Bus.shared.bundle, compatibleWith: nil) ?? UIColor.white
    }
    
    @available(*, deprecated, message: "Use 'contentIOS' color")
    public class var overlay: UIColor {
        return UIColor(named: "overlay", in: Bus.shared.bundle, compatibleWith: nil) ?? UIColor.white
    }
    
    @available(*, deprecated, message: "Use 'textPrimary' color")
    public class var text: UIColor {
        return UIColor(named: "text", in: Bus.shared.bundle, compatibleWith: nil) ?? UIColor.black
    }
    
    @available(*, deprecated, message: "Use 'buttonSecondary' color")
    public class var secondaryButtonColor: UIColor {
        return UIColor(named: "Secondary_button", in: Bus.shared.bundle, compatibleWith: nil) ?? UIColor.red
    }
    
    @available(*, deprecated, message: "Use 'textSecondary' color")
    public class var grey: UIColor {
        return UIColor(named: "grey", in: Bus.shared.bundle, compatibleWith: nil) ?? UIColor.gray
    }
    
    @available(*, deprecated, message: "Use 'textSecondary' color")
    public class var grey2: UIColor {
        return UIColor(named: "grey2", in: Bus.shared.bundle, compatibleWith: nil) ?? UIColor.gray
    }
    
    @available(*, deprecated, message: "Use 'baseiOS' color")
    public class var navigationBar: UIColor {
        return UIColor(named: "navigationBar", in: Bus.shared.bundle, compatibleWith: nil) ?? UIColor.green
    }
    
    @available(*, deprecated, message: "Use 'main' color")
    public class var metroBookmark: UIColor {
        return UIColor(named: "bookmark", in: Bus.shared.bundle, compatibleWith: nil) ?? UIColor.orange
    }
    
    @available(*, deprecated, message: "Use '' color")
    public class var MKOpacityButton: UIColor {
        return UIColor(named: "opacityButton", in: Bus.shared.bundle, compatibleWith: nil) ?? UIColor.grey
    }
    
    @available(*, deprecated, message: "Use 'textfield' color")
    public class var MKTextfield: UIColor {
        return UIColor(named: "textfield", in: Bus.shared.bundle, compatibleWith: nil) ?? UIColor.grey
    }
    
    @available(*, deprecated, message: "Use 'Content' color")
    public class var cardBackground: UIColor {
        return UIColor(named: "card_background", in: Bus.shared.bundle, compatibleWith: nil) ?? .white
    }
    
    @available(*, deprecated, message: "Use 'information' color")
    public class var metroLink: UIColor {
        return UIColor(named: "link", in: Bus.shared.bundle, compatibleWith: nil) ?? UIColor.green
    }
    
    @available(*, deprecated, message: "Use 'red' color")
    public class var metroClosing: UIColor {
        return UIColor(named: "closing", in: Bus.shared.bundle, compatibleWith: nil) ?? UIColor.red
    }
    
    @available(*, deprecated, message: "Use 'green' color")
    public class var metroGreen: UIColor {
        return UIColor(named: "metro_green", in: Bus.shared.bundle, compatibleWith: nil) ?? UIColor.green
    }
    
    @available(*, deprecated, message: "Use 'red' color")
    public class var metroRed: UIColor {
        return UIColor(named: "metro_red", in: Bus.shared.bundle, compatibleWith: nil) ?? UIColor.red
    }
    
    @available(*, deprecated, message: "Use 'warning' color")
    public class var metroOrange: UIColor {
        return UIColor(named: "metro_orange", in: Bus.shared.bundle, compatibleWith: nil) ?? UIColor.orange
    }
    
    @available(*, deprecated, message: "Use 'textInverted' color")
    public class var invertedText: UIColor {
        return UIColor(named: "InvertedTextColor", in: Bus.shared.bundle, compatibleWith: nil) ?? UIColor.black
    }
    
    @available(*, deprecated, message: "Use 'baseiOS' color")
    public class var mapBackground: UIColor {
        return UIColor(named: "mapBackground", in: Bus.shared.bundle, compatibleWith: nil) ?? UIColor.white
    }
    
    public class var parking : UIColor {
        return UIColor(named: "Parking", in: Bus.shared.bundle, compatibleWith: nil) ?? UIColor.green
    }
}
