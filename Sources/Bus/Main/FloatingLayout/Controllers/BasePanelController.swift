//
//  BaseFloatingController.swift
//  MosmetroNew
//
//  Created by Владимир Камнев on 10.06.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import UIKit
import FloatingPanel

class BasePanelController : FloatingPanelController {
    
    ///  Initialization with setting the starting position and case of states for panel acnhors
    /// - Parameters:
    ///   - contentVC: view controller responsible for the content portion of a panel
    ///   - positions:         case anchors positions for the panel
    ///   - state:                the initial state when a panel is presented
    init(contentVC: UIViewController?, positions: AnchorPosition, state: FloatingPanelState = .half) {
        super.init(delegate: nil)
        guard contentVC != nil else { return }
        
        isRemovalInteractionEnabled = true
        self.layout    =       BasePanelLayout(state: state, position: positions)
        setupSurface()
        set(contentViewController: contentVC)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSurface() {
        surfaceView.backgroundColor = .clear
        surfaceView.appearance      = FloatingPanelController.metroAppereance()
    }
}
