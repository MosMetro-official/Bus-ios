import UIKit
import Localize_Swift

public enum Language: String {
    case ru = "ru"
    case en = "en"
}

public class Bus {
            
    public static let shared = Bus()
    
    public var token: String?
    
    public var bundle : Bundle {
        let podBundle = Bundle(for: type(of: self))
        guard let url = podBundle.url(forResource: "MetroRechka", withExtension: "bundle") else {
            return podBundle
        }
        return Bundle(url: url) ?? podBundle
    }
    
    public var language : Language = .ru {
        didSet {
            setInitialLanguage(language)
        }
    }
    
    public weak var authDelegate: B_AuthDelegate?
    
    public weak var refreshDelegate: B_RefreshTokenDelegate?
    
    private init() { }
    
    public func isBusesAvailable() -> Bool {
        return Constants.isBusesAvailable
    }
    
    public func checkAvailability() {
        BusTicketService.checkAvailability()
    }
    
    public static func registerFonts() {
        _ = UIFont.registerFont(bundle: Bus.shared.bundle, fontName: "MoscowSans-Bold", fontExtension: "otf")
        _ = UIFont.registerFont(bundle: Bus.shared.bundle, fontName: "MoscowSans-Regular", fontExtension: "otf")
        _ = UIFont.registerFont(bundle: Bus.shared.bundle, fontName: "MoscowSans-Medium", fontExtension: "otf")
        _ = UIFont.registerFont(bundle: Bus.shared.bundle, fontName: "MoscowSans-Extrabold", fontExtension: "otf")
        _ = UIFont.registerFont(bundle: Bus.shared.bundle, fontName: "MoscowSans-Light", fontExtension: "otf")
    }
    
    @objc
    public func showBusFlow() -> UINavigationController {
        return UINavigationController(rootViewController: BusTicketHomeController())
    }
    
    @objc
    public func showHistory() -> UIViewController {
        let controller = OrderHistoryController()
        return controller
    }
    
    @objc
    public func showOnboarding() -> UIViewController {
        let controller = OnboardingController()
        return controller
    }
    
    private func setInitialLanguage(_ language: Language) {
        Localize.setCurrentLanguage("ru")
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
