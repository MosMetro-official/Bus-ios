//
//  Constants.swift
//  MosmetroNew
//
//  Created by Сеня Римиханов on 04.05.2020.
//  Copyright © 2020 Гусейн Римиханов. All rights reserved.
//

import UIKit

@objc final class Constants: NSObject {
  
    static let MAPKIT_API_KEY = "dee693d0-349d-4757-9a94-e9a237abb930"
    
    /**
     Each key is encoded as array bytes.
     For encoding string value to bytes, use any online converter.
     
     # Example #
     https://onlinestringtools.com/convert-string-to-bytes
     
     Source string value: keychainUUIDString
     Converted String as bytes: 6b 65 79 63 68 61 69 6e 55 55 49 44 53 74 72 69 6e 67
     
     # Storing bytes in code #
     All bytes stored as [UInt8].
     For correct storing every byte you need add 0x before every byte value.
     
     # Example #
     Bytes from online converter: 6b 65 79 63 68 61 69 6e 55 55 49 44 53 74 72 69 6e 67
     Bytes for save in code: [0x6b, 0x65, 0x79, 0x63, 0x68, 0x61, 0x69, 0x6e, 0x55, 0x55, 0x49, 0x44, 0x53, 0x74, 0x72, 0x69, 0x6e, 0x67]
     
     */
    
    // Encoded key: auth.token
    @objc static let kAuthData: [UInt8] = [0x61, 0x75, 0x74, 0x68, 0x2e, 0x74, 0x6f, 0x6b, 0x65, 0x6e]
    // Encoded key: refresh
    @objc static let kRefreshToken: [UInt8] = [0x72, 0x65, 0x66, 0x72, 0x65, 0x73, 0x68]
    // Encoded key: token
    @objc static let kAccessToken: [UInt8] = [0x74, 0x6f, 0x6b, 0x65, 0x6e]
    // Encoded key: API_CLIENT_ID
    @objc static let kClientId: [UInt8] = [0x41, 0x50, 0x49, 0x5f, 0x43, 0x4c, 0x49, 0x45, 0x4e, 0x54, 0x5f, 0x49, 0x44]
    // Encoded key: API_CLIENT_SECRET
    @objc static let kClientSecret: [UInt8] = [0x41, 0x50, 0x49, 0x5f, 0x43, 0x4c, 0x49, 0x45, 0x4e, 0x54, 0x5f, 0x53, 0x45, 0x43, 0x52, 0x45, 0x54]
    
    static var authHost: String {
        if let host = Bundle.main.infoDictionary?["AUTH_HOST"] as? String {
            return host
        }
        return ""
    }
    
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
    
    #if !APPCLIP
    @objc static let isBusesAvailable = true
//    @objc static let isRiverAvailable = MetroRechka.shared.isRiverAvailable
    @objc static let hasSeenPromo = BusTicketService.isBusesAvailable
    #endif
    
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

class MetroSearchBar: UISearchBar { }
class CitySearchBar : UISearchBar { }
