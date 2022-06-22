//
//  ParkingUnauthorizedModel.swift
//  MosmetroNew
//
//  Created by Гусейн on 29.07.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import UIKit

struct ParkingUnauthorizedModel: B_BottomModalViewable {
    var buttonText: String
    var image: UIImage
    var title: String
    var subtitle: String
    var onClose: () -> ()
    var onAction: () -> ()
}
