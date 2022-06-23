//
//  NewColor.swift
//  MosmetroNew
//
//  Created by Владимир Камнев on 15.06.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import UIKit

extension UIColor {
    
    public class var main: UIColor {
        return UIColor(named: "NewMain", in: Bus.shared.bundle, compatibleWith: nil) ?? UIColor.systemRed
    }
    
    public class var baseIOS: UIColor {
        return UIColor(named: "BaseIOS", in: Bus.shared.bundle, compatibleWith: nil) ?? UIColor.white
    }
    
    public class var contentIOS: UIColor {
        return UIColor(named: "card_background", in: Bus.shared.bundle, compatibleWith: nil) ?? UIColor.white
    }
    
    public class var textPrimary: UIColor {
        return UIColor(named: "TextPrimary", in: Bus.shared.bundle, compatibleWith: nil) ?? UIColor.black
    }
    
    public class var textInverted: UIColor {
        return UIColor(named: "InvertedTextColor", in: Bus.shared.bundle, compatibleWith: nil) ?? UIColor.black
    }
    
    public class var textSecondary: UIColor {
        return UIColor(named: "TextSecondary", in: Bus.shared.bundle, compatibleWith: nil) ?? UIColor.gray
    }
    
    public class var buttonSecondary: UIColor {
        return UIColor(named: "ButtonSecondary", in: Bus.shared.bundle, compatibleWith: nil) ?? UIColor.gray
    }
    
    public class var buttonTertiary: UIColor {
        return UIColor(named: "ButtonTertiary", in: Bus.shared.bundle, compatibleWith: nil) ?? UIColor.gray
    }
    
    public class var textfield: UIColor {
        return UIColor(named: "NewTextfield", in: Bus.shared.bundle, compatibleWith: nil) ?? UIColor.white
    }
    
    public class var separator: UIColor {
        return UIColor(named: "NewSeparator", in: Bus.shared.bundle, compatibleWith: nil) ?? UIColor.white
    }
    
    public class var green: UIColor {
        return UIColor(named: "Green", in: Bus.shared.bundle, compatibleWith: nil) ?? UIColor.white
    }
    
    public class var red: UIColor {
        return UIColor(named: "Red", in: Bus.shared.bundle, compatibleWith: nil) ?? UIColor.systemRed
    }
    
    public class var iconTertiary: UIColor {
        return UIColor(named: "IconTertiary", in: Bus.shared.bundle, compatibleWith: nil) ?? UIColor.gray
    }
    
    public class var toolBarAction: UIColor {
        return UIColor(named: "ToolBarAction", in: Bus.shared.bundle, compatibleWith: nil) ?? UIColor.gray
    }
    
    public class var toolBarBack: UIColor {
        return UIColor(named: "ToolBarBack", in: Bus.shared.bundle, compatibleWith: nil) ?? UIColor.gray
    }

    public class var warning : UIColor {
        return UIColor(named: "Warning", in: Bus.shared.bundle, compatibleWith: nil) ?? UIColor.green
    }

    public class var information : UIColor {
        return UIColor(named: "Information", in: Bus.shared.bundle, compatibleWith: nil) ?? UIColor.green
    }

    public class var content2: UIColor {
        return UIColor(named: "Content2", in: Bus.shared.bundle, compatibleWith: nil) ?? UIColor.white
    }
}
