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
    
    static func getTotalTimeString(from dateComponents: DateComponents) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute]
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .default
        return formatter.string(from: dateComponents)
    }
}
