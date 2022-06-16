//
//  PanelBehavior.swift
//  MosmetroNew
//
//  Created by Павел Кузин on 24.11.2020.
//  Copyright © 2020 Гусейн Римиханов. All rights reserved.
//

import UIKit
import FloatingPanel

class DetailsPanelBehavior: FloatingPanelBehavior {
    
    var removalVelocity: CGFloat {
        return 0.4
    }
    
    var removalProgress: CGFloat {
        return 0.5
    }
    
    private func shouldProjectMomentum(_ fpc: FloatingPanelController, for proposedTargetPosition: FloatingPanelPosition) -> Bool {
        return true
    }
}
