//
//  B_Bundle.swift
//  
//
//  Created by polykuzin on 24/06/2022.
//

import Foundation

private class BundleFinder {}

public extension Bundle {
    
    static var b_Bundle : Bundle = {
        let bundleName = "Bus_Bus"
        let candidates = [
            Bundle.main.resourceURL,
            Bundle(for: BundleFinder.self).resourceURL,
            Bundle.main.bundleURL,
            Bundle(for: BundleFinder.self).resourceURL?.deletingLastPathComponent().deletingLastPathComponent(),
        ]
        for candidate in candidates {
            let bundlePath = candidate?.appendingPathComponent(bundleName + ".bundle")
            if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
                return bundle
            }
        }
        fatalError("unable to find bundle named \(bundleName)")
    }()
}
