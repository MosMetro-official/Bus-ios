//
//  Utility Model.swift
//  MosmetroNew
//
//  Created by Сеня Римиханов on 07.05.2020.
//  Copyright © 2020 Гусейн Римиханов. All rights reserved.
//

import UIKit
import SwiftDate
import Localize_Swift

class Utils {
    
    //MARK: - Get Root VC
    static func root() -> UIViewController? {
        if let root = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController {
            return root
        }
        return nil
    }
    
    //MARK: - HTML to String
    static func convert(html toString: String) -> NSMutableAttributedString {
        let htmlText = toString.htmlToAttributedString
        let mutableStr = NSMutableAttributedString(attributedString: htmlText!)
        mutableStr.setFontFace(font: UIFont.BODY_S, color: .textPrimary)
        return mutableStr
    }
    
    //MARK: - Time From Now
    static func getTimeFromNow(_ seconds: Double) -> String {
        let moscow = Region(calendar: Calendars.gregorian, zone: Zones.europeMoscow, locale: Locales.russian)
        let date = DateInRegion(Date(), region: moscow)
        let time = date.dateByAdding(Int(seconds), .second)
        return time.toFormat("H:mm")
    }
    
    //MARK: - Period of Time
    static func getPeriodFromNow(_ seconds: Double) -> String {
        let moscow = Region(calendar: Calendars.gregorian, zone: Zones.europeMoscow, locale: Locales.russian)
        let date = DateInRegion(Date(), region: moscow)
        let end = date.dateByAdding(Int(seconds), .second)
        
        //let period = TimePeriod(start: date, end: date.dateByAdding(Int(seconds/60), .minute))
        return "\(date.toFormat("H:mm")) – \(end.toFormat("H:mm"))"
    }
    
    //MARK: - Total Time
    static func getTotalTime(_ seconds: Double, units: NSCalendar.Unit = [.hour,.minute]) -> String {
        let moscow = Region(calendar: Calendars.gregorian, zone: Zones.europeMoscow, locale: Localize.currentLanguage() == "ru" ?  Locales.russian : Locales.english)
        let date = DateInRegion(Date(), region: moscow)
        let period = TimePeriod(start: date, end: date.dateByAdding(Int(seconds/60), .minute))
        let duration = period.duration
        return duration.toString {
            $0.maximumUnitCount = 4
            //$0.allowedUnits = [.hour, .minute]
            $0.allowedUnits = units
            $0.collapsesLargestUnit = false
            $0.unitsStyle = .abbreviated
        }
    }
    
    // MARK: - Moscow Time
    static func getMoscowDate() -> DateInRegion {
        let moscow = Region(calendar: Calendars.gregorian, zone: Zones.europeMoscow, locale: Localize.currentLanguage() == "ru" ?  Locales.russian : Locales.english)
        return DateInRegion(Date(), region: moscow)
    }
    
    //MARK: - Total Time (seconds)
    static func getAudioTotalTime(_ seconds: Double) -> String {
        let moscow = Region(calendar: Calendars.gregorian, zone: Zones.europeMoscow, locale: Localize.currentLanguage() == "ru" ?  Locales.russian : Locales.english)
        let date = DateInRegion(Date(), region: moscow)
        let period = TimePeriod(start: date, end: date.dateByAdding(Int(seconds), .second))
        let duration = period.duration
        return duration.toString {
            $0.maximumUnitCount = 0
            $0.allowedUnits = [.hour, .minute, .second]
            $0.collapsesLargestUnit = false
            $0.zeroFormattingBehavior = .pad
            $0.unitsStyle = .positional
        }
    }
    
    static func getTotalTimeString(from dateComponents: DateComponents) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute]
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .default
        return formatter.string(from: dateComponents)
    }
    
    //MARK: - Get status bar Height
    static func getStatusBarHeight() -> CGFloat {
       var statusBarHeight: CGFloat = 0
       if #available(iOS 13.0, *) {
           let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
           statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
       } else {
           statusBarHeight = UIApplication.shared.statusBarFrame.height
       }
        return statusBarHeight
    }
    
    //MARK: - Arrival Time
    static func getArrivalTime(_ seconds: Double) -> String {
        let moscow = Region(calendar: Calendars.gregorian, zone: Zones.europeMoscow, locale: Localize.currentLanguage() == "ru" ?  Locales.russian : Locales.english)
        let date = DateInRegion(Date(), region: moscow)
        return date.dateByAdding(Int(seconds), .second).toString(.time(.short))
        
    }
    
    //MARK: - Get Top Padding
    static func getTopPadding() -> CGFloat {
        let window = UIApplication.shared.keyWindow
        guard let topPadding = window?.safeAreaInsets.top else { return 0 }
        return topPadding
    }
    
    // MARK: - Get String Distance
    static func distanceToString(from distance: Double) -> String {
        let roundDistance   = distance.rounded(.toNearestOrAwayFromZero)
        return roundDistance > 1000 ? String.localizedStringWithFormat("%@ km".localized(in: .module), "\((roundDistance/1000).roundToDecimal(2))") : String.localizedStringWithFormat("%@ m".localized(in: .module), "\(roundDistance.roundToDecimal(2))")
    }
    
    static func downsample(image data: Data,
                    to pointSize: CGSize,
                    scale: CGFloat = UIScreen.main.scale, callback: @escaping (UIImage?) -> ()) {
        
        // Create an CGImageSource that represent an image
        DispatchQueue.global(qos: .userInteractive).async {
            let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
            guard let imageSource = CGImageSourceCreateWithData(data as CFData, imageSourceOptions) else {
                callback(nil)
                return
            }
            
            // Calculate the desired dimension
            let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale
            
            // Perform downsampling
            let downsampleOptions = [
                kCGImageSourceCreateThumbnailFromImageAlways: true,
                kCGImageSourceShouldCacheImmediately: true,
                kCGImageSourceCreateThumbnailWithTransform: true,
                kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels
            ] as CFDictionary
            guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else {
                callback(nil)
                return
            }
            callback(UIImage(cgImage: downsampledImage))
        }
    }
}

public struct Units {
  
  public let bytes: Int64
  
  public var kilobytes: Double {
    return Double(bytes) / 1_024
  }
  
  public var megabytes: Double {
    return kilobytes / 1_024
  }
  
  public var gigabytes: Double {
    return megabytes / 1_024
  }
  
  public init(bytes: Int64) {
    self.bytes = bytes
  }
  
  public func getReadableUnit() -> String {
    
    switch bytes {
    case 0..<1_024:
      return "\(bytes) bytes"
    case 1_024..<(1_024 * 1_024):
      return "\(String(format: "%.2f", kilobytes)) kb"
    case 1_024..<(1_024 * 1_024 * 1_024):
      return "\(String(format: "%.2f", megabytes)) mb"
    case (1_024 * 1_024 * 1_024)...Int64.max:
      return "\(String(format: "%.2f", gigabytes)) gb"
    default:
      return "\(bytes) bytes"
    }
  }
}
