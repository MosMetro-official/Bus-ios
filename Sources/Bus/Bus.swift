import UIKit
import Localize_Swift

public enum Language: String {
    case ru = "ru"
    case en = "en"
}

public class Bus {
            
    public static let shared = Bus()
    
    public var token: String?
        
    public var language: Language = .ru {
        didSet {
            setInitialLanguage(language)
        }
    }
    
    public weak var authDelegate: B_AuthDelegate?
    
    public weak var refreshDelegate: B_RefreshTokenDelegate?
    
    private init() { }
    
    public static func registerFonts() {
        _ = UIFont.registerFont(bundle: .module, fontName: "MoscowSans-Bold", fontExtension: "otf")
        _ = UIFont.registerFont(bundle: .module, fontName: "MoscowSans-Regular", fontExtension: "otf")
        _ = UIFont.registerFont(bundle: .module, fontName: "MoscowSans-Medium", fontExtension: "otf")
        _ = UIFont.registerFont(bundle: .module, fontName: "MoscowSans-Extrabold", fontExtension: "otf")
        _ = UIFont.registerFont(bundle: .module, fontName: "MoscowSans-Light", fontExtension: "otf")
    }
    
    public func showBusFlow() -> UINavigationController {
        return UINavigationController(rootViewController: BusTicketHomeController())
    }
    
    private func setInitialLanguage(_ language: Language) {
        Localize.setCurrentLanguage(language.rawValue)
    }
}

extension UIFont {
    /// Method for register fonts from package
    open class func registerFont(bundle: Bundle, fontName: String, fontExtension: String) -> Bool {
        guard let fontURL = bundle.url(forResource: fontName, withExtension: fontExtension) else {
            fatalError("Couldn't find font \(fontName)")
        }
        guard let fontDataProvider = CGDataProvider(url: fontURL as CFURL) else {
            fatalError("Couldn't load data from the font \(fontName)")
        }
        guard let font = CGFont(fontDataProvider) else {
            fatalError("Couldn't create font from data")
        }
        var error: Unmanaged<CFError>?
        let success = CTFontManagerRegisterGraphicsFont(font, &error)
        guard success else {
            print("Error registering font: maybe it was already registered.")
            return false
        }
        return true
    }
}
