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
        return UIColor(named: "main", in: .module, compatibleWith: nil) ?? UIColor.red
    }
    
    @available(*, deprecated, message: "Use 'baseIOS' color")
    public class var MKBase: UIColor {
        return UIColor(named: "Base", in: .module, compatibleWith: nil) ?? UIColor.white
    }
    
    @available(*, deprecated, message: "Use 'contentIOS' color")
    public class var overlay: UIColor {
        return UIColor(named: "overlay", in: .module, compatibleWith: nil) ?? UIColor.white
    }
    
    @available(*, deprecated, message: "Use 'textPrimary' color")
    public class var text: UIColor {
        return UIColor(named: "text", in: .module, compatibleWith: nil) ?? UIColor.black
    }
    
    @available(*, deprecated, message: "Use 'buttonSecondary' color")
    public class var secondaryButtonColor: UIColor {
        return UIColor(named: "Secondary_button", in: .module, compatibleWith: nil) ?? UIColor.red
    }
    
    @available(*, deprecated, message: "Use 'textSecondary' color")
    public class var grey: UIColor {
        return UIColor(named: "grey", in: .module, compatibleWith: nil) ?? UIColor.gray
    }
    
    @available(*, deprecated, message: "Use 'textSecondary' color")
    public class var grey2: UIColor {
        return UIColor(named: "grey2", in: .module, compatibleWith: nil) ?? UIColor.gray
    }
    
    @available(*, deprecated, message: "Use 'baseiOS' color")
    public class var navigationBar: UIColor {
        return UIColor(named: "navigationBar", in: .module, compatibleWith: nil) ?? UIColor.green
    }
    
    @available(*, deprecated, message: "Use 'main' color")
    public class var metroBookmark: UIColor {
        return UIColor(named: "bookmark", in: .module, compatibleWith: nil) ?? UIColor.orange
    }
    
    @available(*, deprecated, message: "Use '' color")
    public class var MKOpacityButton: UIColor {
        return UIColor(named: "opacityButton", in: .module, compatibleWith: nil) ?? UIColor.grey
    }
    
    @available(*, deprecated, message: "Use 'textfield' color")
    public class var MKTextfield: UIColor {
        return UIColor(named: "textfield", in: .module, compatibleWith: nil) ?? UIColor.grey
    }
    
    @available(*, deprecated, message: "Use 'Content' color")
    public class var cardBackground: UIColor {
        return UIColor(named: "card_background", in: .module, compatibleWith: nil) ?? .white
    }
    
    @available(*, deprecated, message: "Use 'information' color")
    public class var metroLink: UIColor {
        return UIColor(named: "link", in: .module, compatibleWith: nil) ?? UIColor.green
    }
    
    @available(*, deprecated, message: "Use 'red' color")
    public class var metroClosing: UIColor {
        return UIColor(named: "closing", in: .module, compatibleWith: nil) ?? UIColor.red
    }
    
    @available(*, deprecated, message: "Use 'green' color")
    public class var metroGreen: UIColor {
        return UIColor(named: "metro_green", in: .module, compatibleWith: nil) ?? UIColor.green
    }
    
    @available(*, deprecated, message: "Use 'red' color")
    public class var metroRed: UIColor {
        return UIColor(named: "metro_red", in: .module, compatibleWith: nil) ?? UIColor.red
    }
    
    @available(*, deprecated, message: "Use 'warning' color")
    public class var metroOrange: UIColor {
        return UIColor(named: "metro_orange", in: .module, compatibleWith: nil) ?? UIColor.orange
    }
    
    @available(*, deprecated, message: "Use 'textInverted' color")
    public class var invertedText: UIColor {
        return UIColor(named: "InvertedTextColor", in: .module, compatibleWith: nil) ?? UIColor.black
    }
    
    @available(*, deprecated, message: "Use 'baseiOS' color")
    public class var mapBackground: UIColor {
        return UIColor(named: "mapBackground", in: .module, compatibleWith: nil) ?? UIColor.white
    }
    
    public class var parking : UIColor {
        return UIColor(named: "Parking", in: .module, compatibleWith: nil) ?? UIColor.green
    }
}
