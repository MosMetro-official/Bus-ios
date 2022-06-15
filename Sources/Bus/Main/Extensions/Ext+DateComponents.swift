//
//  File.swift
//  
//
//  Created by Слава Платонов on 07.06.2022.
//

import Foundation

extension DateComponents: Comparable {
    
    public static func < (lhs: DateComponents, rhs: DateComponents) -> Bool {
        
        if let lhsDate = Date(components: lhs, region: nil), let rhsDate = Date(components: rhs, region: nil) {
            let comp = lhsDate.compare(rhsDate)
            switch comp {
            case .orderedAscending:
                return true
            case .orderedSame:
                return false
            case .orderedDescending:
                return false
            }
        }
        return false
    }
}
