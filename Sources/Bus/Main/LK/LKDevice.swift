//
//  LKDevice.swift
//  MosmetroNew
//
//  Created by Максим Филимонов on 02.03.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import UIKit

final class LKDevice {
    
    public var model: String {
        get { return deviceModel() }
    }
    
    public var os: String {
        get { return deviceOS() }
    }
    
    public var uuid: String {
        get { deviceUUID() }
    }
    
    public var userAgent: String {
        get { deviceUserAgent() }
    }
    
    public var language: String? {
        get { deviceLanguage() }
    }
    
    private var appVersion: String? {
        get { deviceAppVersion() }
    }
    
    private var bundleSignature: String? {
        get { deviceBundleSignature() }
    }
    
    static var shared: LKDevice {
        let instance = LKDevice()
        return instance
    }
    
    init() {}
}

extension LKDevice {
    
    fileprivate func deviceAppVersion() -> String? {
        guard
            let build = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String,
            let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        else {
            return nil
        }
        return "\(version) (\(build))"
    }
    
    fileprivate func deviceLanguage() -> String? {
        return Locale.preferredLanguages.first
    }
    
    fileprivate func deviceModel() -> String {
        return UIDevice.modelName
    }
    
    fileprivate func deviceOS() -> String {
        return UIDevice.current.systemVersion
    }
    
    fileprivate func deviceUUID() -> String {
        return UIDevice.current.identifierForVendor?.uuidString ?? ""
    }
    
    fileprivate func deviceBundleSignature() -> String? {
        guard let infoPlistUrl = Bundle.main.url(forResource: "Info", withExtension: "plist") else {
            return nil
        }
        
        var signature = "00000000"
        
        do {
            let plistFile = try FileHandle(forReadingFrom: infoPlistUrl)
            let fileData = plistFile.readDataToEndOfFile()
            let dataLength = fileData.count
            fileData.withUnsafeBytes { ptr in
                guard let bytes = ptr.baseAddress?.assumingMemoryBound(to: Int8.self) else {
                    return
                }
                
                var crc = 0
                
                for i in 0..<dataLength {
                    crc ^= Int(bytes[i])
                    
                    for _ in 0..<8 {
                        var b = 0
                        
                        if crc == 1 {
                            b = 0xd5828281
                        }
                        crc = ((crc>>1) & 0x7fffffff) ^ b
                    }
                    crc ^= 0xd202ef8d
                }
                
                signature = String(format: "%08X", crc)
            }
            
            
        } catch(let error) {
            print("Read Info.plist failed with error: \(error)")
            return nil
        }
        
        return signature
    }
    
    fileprivate func deviceUserAgent() -> String {
        let defaultUserAgent = String(format: "Mozilla/5.0 (iPhone; CPU iPhone OS %@ like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Mobile/15E148 Safari/604.1", os)
        
        if #available(iOS 13, *) {
            guard let appVersion = appVersion,
                  let bundleSignature = bundleSignature else {
                return defaultUserAgent
            }
            
            return String(format: "MosMetro/%@ (iOS; %@; %@; %@)", appVersion, model, os, bundleSignature)
        } else {
            return defaultUserAgent
        }
    }
}
