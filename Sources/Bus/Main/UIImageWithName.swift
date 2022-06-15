//
//  UIImageWithName.swift
//  MosmetroNew
//
//  Created by polykuzin on 21/02/2022.
//  Copyright © 2022 Гусейн Римиханов. All rights reserved.
//
// swiftlint:disable custom_literal

import UIKit

class UIImageWithName : UIImage {

    convenience init(_ name: String) {
        if
            let image = UIImage(named: name),
            let cgImage = image.cgImage
        {
            self.init(cgImage: cgImage, scale: image.scale, orientation: image.imageOrientation)
        } else {
            let image = UIImage()
            let cgImage = image.cgImage
            self.init(cgImage: cgImage!)
        }
    }
}
