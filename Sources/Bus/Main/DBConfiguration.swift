//
//  DBConfiguration.swift
//  MosmetroNew
//
//  Created by Гусейн on 14.12.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import RealmSwift
import Realm
import Darwin
import Security

let realmActualVersion : UInt64 = 27

extension Realm.Configuration {
    
    private static let busSchemaVersion: UInt64 = realmActualVersion
    
    public static var busConfiguration : Realm.Configuration {
        
        var config = Realm.Configuration(encryptionKey: KeychainKey.getKey())
        config.schemaVersion = busSchemaVersion
        
        config.objectTypes = [
            DocumentDTO.self,
            PassengerDTO.self,
            CountryDTO.self,
            CountryDTOData.self
        ]
        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("buses.realm")
        return config
    }
}

struct KeychainKey {
    
    static func printResultCode(resultCode: OSStatus) {
            // See: https://www.osstatus.com/
            switch resultCode {
            case errSecSuccess:
                print("Keychain Status: No error.")
            case errSecUnimplemented:
                print("Keychain Status: Function or operation not implemented.")
            case errSecIO:
                print("Keychain Status: I/O error (bummers)")
            case errSecOpWr:
                print("Keychain Status: File already open with with write permission")
            case errSecParam:
                print("Keychain Status: One or more parameters passed to a function where not valid.")
            case errSecAllocate:
                print("Keychain Status: Failed to allocate memory.")
            case errSecUserCanceled:
                print("Keychain Status: User canceled the operation.")
            case errSecBadReq:
                print("Keychain Status: Bad parameter or invalid state for operation.")
            case errSecInternalComponent:
                print("Keychain Status: Internal Component")
            case errSecNotAvailable:
                print("Keychain Status: No keychain is available. You may need to restart your computer.")
            case errSecDuplicateItem:
                print("Keychain Status: The specified item already exists in the keychain.")
            case errSecItemNotFound:
                print("Keychain Status: The specified item could not be found in the keychain.")
            case errSecInteractionNotAllowed:
                print("Keychain Status: User interaction is not allowed.")
            case errSecDecode:
                print("Keychain Status: Unable to decode the provided data.")
            case errSecAuthFailed:
                print("Keychain Status: The user name or passphrase you entered is not correct.")
            default:
                print("Keychain Status: Unknown. (\(resultCode))")
            }
        }
    
    static func getKey() -> Data {
        // Identifier for our keychain entry - should be unique for your application
        let keychainIdentifier = "ru.mosmetro.realmencryptionkey"
        let keychainIdentifierData = keychainIdentifier.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        // First check in the keychain for an existing key
        var query: [NSString: AnyObject] = [
            kSecClass: kSecClassKey,
            kSecAttrApplicationTag: keychainIdentifierData as AnyObject,
            kSecAttrKeySizeInBits: 512 as AnyObject,
            kSecReturnData: true as AnyObject
        ]
        // To avoid Swift optimization bug, should use withUnsafeMutablePointer() function to retrieve the keychain item
        // See also: http://stackoverflow.com/questions/24145838/querying-ios-keychain-using-swift/27721328#27721328
        var dataTypeRef: AnyObject?
        var status = withUnsafeMutablePointer(to: &dataTypeRef) { SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0)) }
        if status == errSecSuccess {
            //  swiftlint:disable force_cast
            return dataTypeRef as! Data
            //  swiftlint:enable force_cast
        }
        // No pre-existing key from this application, so generate a new one
        // Generate a random encryption key
        var key = Data(count: 64)
        key.withUnsafeMutableBytes({ (pointer: UnsafeMutableRawBufferPointer) in
            let result = SecRandomCopyBytes(kSecRandomDefault, 64, pointer.baseAddress!)
            assert(result == 0, "Failed to get random bytes")
        })
        // Store the key in the keychain
        query = [
            kSecClass: kSecClassKey,
            kSecAttrApplicationTag: keychainIdentifierData as AnyObject,
            kSecAttrKeySizeInBits: 512 as AnyObject,
            kSecValueData: key as AnyObject
        ]
        status = SecItemAdd(query as CFDictionary, nil)
        
        printResultCode(resultCode: status)
        return key
    }
}
