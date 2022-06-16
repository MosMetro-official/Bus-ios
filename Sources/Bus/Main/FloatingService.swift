//
//  PanelControllerFabrica.swift
//  MosmetroNew
//
//  Created by Владимир Камнев on 21.06.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import FloatingPanel
import UIKit

struct FloatingService {
    
    /// Initialization BasePanelController with setting the starting position and case of states for panel acnhors
    /// - Parameters:
    ///   - contentVC: view controller responsible for the content portion of a panel
    ///   - positions: case anchors positions for the panel
    ///   - state: the initial state when a panel is presented
    static func getPanel(contentVC: UIViewController, positions: AnchorPosition, state: FloatingPanelState) -> BasePanelController {
        return BasePanelController(contentVC: contentVC, positions: positions, state: state)
    }
}
