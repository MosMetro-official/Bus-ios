//
//  Constants.swift
//  MosmetroNew
//
//  Created by Сеня Римиханов on 04.05.2020.
//  Copyright © 2020 Гусейн Римиханов. All rights reserved.
//

import UIKit

final class Constants: NSObject {
    
    static var tokenEndpoint: String {
        if let endpoint = Bundle.main.infoDictionary?["AUTH_TOKEN_ENDPOINT"] as? String {
            return endpoint
        }
        return ""
    }
    
    static var metro_api : String {
        if UserDefaults.standard.bool(forKey: "METRO_API") {
            return "devapp.mosmetro.ru"
        } else {
            return "prodapp.mosmetro.ru"
        }
    }
    
    static let isBusesAvailable = true
    
    static let hasSeenPromo = BusTicketService.isBusesAvailable
    
    public static func userAuthorized() -> Bool {
        //        return LKAuth.shared.accessToken == "" ? false : true
        return Bus.shared.token != nil
    }
    
    static var isDarkModeEnabled: Bool {
        if let theme = UserDefaults.standard.object(forKey: "AppApereance") as? String {
            if #available(iOS 13.0, *) {
                if theme == "dark" {
                    return true
                } else if theme == "light" {
                    return false
                } else {
                    return false
                }
            }
        } else {
            if #available(iOS 12.0, *) {
                switch UIScreen.main.traitCollection.userInterfaceStyle {
                case .dark:
                    return true
                case .light:
                    return false
                case .unspecified:
                    return false
                @unknown default:
                    fatalError()
                }
            } else {
                return false
            }
        }
        return false
    }
}
