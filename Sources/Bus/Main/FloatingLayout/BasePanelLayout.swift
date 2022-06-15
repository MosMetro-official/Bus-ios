//
//  BasePanelLayout.swift
//  MosmetroNew
//
//  Created by Владимир Камнев on 10.06.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import FloatingPanel
import UIKit

/// Enum of state positions BasePanelController
///
/// - **modal**             is the classic position as modal view
/// - **all**                    contains 3 positions: modal, half and tip
/// - **modalCenter**  contains 2 position: modal and half
/// - **fullScreen**       the controller is displayed in full screen
/// - **guideLayout**  positions for GuideController
public enum AnchorPosition {
    case modal
    case all
    case modalCenter
    case fullScreen
    case guideLayout
}

public enum TypeDevices {
    case oldModels
    case newModels
    case allModels
}

// MARK: - Devices fabrica
/// This structure contains a method that returns an array of mobile device names
public struct DevicesFabrica {
    
    /**
     This method returns an array of mobile device names
     
     - Parameters:
       - type: devices type
     - Returns: array of mobile device names
     */
    static func get(with type: TypeDevices) -> [String] {
        switch type {
        case .newModels :
            return ["iPhone 6", "iPhone 6s", "iPhone 7",
                    "iPhone 8", "iPod touch (6th generation)", "iPod touch (7th generation)",
                    /*"Simulator iPhone 6", "Simulator iPhone 6s", "Simulator iPhone 7",
                    "Simulator iPhone 8", "Simulator iPod touch (6th generation)", "Simulator iPod touch (7th generation)"*/]
        case .oldModels :
            return ["iPhone 5c", "iPhone 5s", "iPhone SE",
                  /*  "Simulator iPhone 5c", "Simulator iPhone 5s", "Simulator iPhone SE"*/]
        case .allModels :
            return ["iPhone 5c", "iPhone 5s", "iPhone SE",
                    "iPhone 6" , "iPhone 6s", "iPhone 7",
                    "iPhone 8", "iPod touch (6th generation)", "iPod touch (7th generation)",
                   /* "Simulator iPhone 5c", "Simulator iPhone 5s", "Simulator iPhone SE",
                    "Simulator iPhone 6" , "Simulator iPhone 6s", "Simulator iPhone 7",
                    "Simulator iPhone 8" , "Simulator iPod touch (6th generation)", "Simulator iPod touch (7th generation)" */]
        }
    }
    
    private init() {}
}

// MARK: - BasePanelLayout
/// An interface for generating layout information for a panel
class BasePanelLayout: NSObject, FloatingPanelLayout {
    
    //MARK: - Properties
    let position     : FloatingPanelPosition = .bottom
    var initialState : FloatingPanelState
    var anchors      : [FloatingPanelState : FloatingPanelLayoutAnchoring] = [:]
    
    /// Initialization with setting the starting position and case of states for panel acnhors
    /// - Parameters:
    ///   - state:    the initial state when a panel is presented
    ///   - position: case anchors positions for the panel
    init(state: FloatingPanelState = .full, position: AnchorPosition) {
        
        initialState = state
        super.init()
        self.anchors = getAnchors(position)
    }
    
    /// Anchor position generation method depending on the model of the mobile device
    /// - Parameter position: - case contains of state positions BasePanelController
    /// - Returns: achor position in depending on the model of the mobile device
    private func getAnchors(_ position: AnchorPosition) -> [FloatingPanelState : FloatingPanelLayoutAnchoring] {
        
        switch position {
        case .modal         :
            var newAnchor: [FloatingPanelState : FloatingPanelLayoutAnchoring] {
                return [
                    .full : FloatingPanelLayoutAnchor(absoluteInset: 16, edge: .top, referenceGuide: .safeArea)
                ]
            }
            return newAnchor
        case .modalCenter     :
            switch UIDevice.modelName {
            case let device where DevicesFabrica.get(with: .allModels).contains(device) :
                var newAnchor: [FloatingPanelState : FloatingPanelLayoutAnchoring] {
                    return [
                        .full   : FloatingPanelLayoutAnchor(absoluteInset:     32, edge: .top,    referenceGuide: .safeArea  ),
                        .half   : FloatingPanelLayoutAnchor(fractionalInset: 0.45, edge: .bottom, referenceGuide: .superview )
                    ]
                }
                return newAnchor
            default:
                var newAnchor: [FloatingPanelState : FloatingPanelLayoutAnchoring] {
                    return [
                        .full   : FloatingPanelLayoutAnchor(absoluteInset:     32, edge: .top,    referenceGuide: .safeArea  ),
                        .half   : FloatingPanelLayoutAnchor(fractionalInset: 0.45, edge: .bottom, referenceGuide: .superview )
                    ]
                }
                return newAnchor
            }
        case .all           :
            switch UIDevice.modelName {
            case let device where DevicesFabrica.get(with: .oldModels).contains(device) :
                var newAnchor: [FloatingPanelState : FloatingPanelLayoutAnchoring] {
                    return [
                        .full   : FloatingPanelLayoutAnchor(absoluteInset   : 32,   edge: .top,    referenceGuide: .safeArea  ),
                        .half   : FloatingPanelLayoutAnchor(fractionalInset : 0.55, edge: .bottom, referenceGuide: .superview ),
                        .tip    : FloatingPanelLayoutAnchor(absoluteInset   : 92,   edge: .bottom, referenceGuide: .safeArea  )
                    ]
                }
                return newAnchor
            case let device where DevicesFabrica.get(with: .newModels).contains(device) :
                var newAnchor: [FloatingPanelState : FloatingPanelLayoutAnchoring] {
                    return [
                        .full   : FloatingPanelLayoutAnchor(absoluteInset   : 32,  edge: .top,    referenceGuide: .safeArea   ),
                        .half   : FloatingPanelLayoutAnchor(fractionalInset : 0.5, edge: .bottom, referenceGuide: .superview  ),
                        .tip    : FloatingPanelLayoutAnchor(absoluteInset   : 92,  edge: .bottom, referenceGuide: .safeArea   )
                    ]
                }
                return newAnchor
            default:
                var newAnchor: [FloatingPanelState : FloatingPanelLayoutAnchoring] {
                    return [
                        .full   : FloatingPanelLayoutAnchor(absoluteInset   : 32,   edge: .top,    referenceGuide: .safeArea  ),
                        .half   : FloatingPanelLayoutAnchor(fractionalInset : 0.45, edge: .bottom, referenceGuide: .superview ),
                        .tip    : FloatingPanelLayoutAnchor(absoluteInset   : 92,   edge: .bottom, referenceGuide: .safeArea  )
                    ]
                }
                return newAnchor
            }
        case .fullScreen    :
            var newAnchor: [FloatingPanelState : FloatingPanelLayoutAnchoring] {
                return [
                    .full: FloatingPanelLayoutAnchor(fractionalInset: 0, edge: .top, referenceGuide: .superview ),
                ]
            }
            return newAnchor
        case .guideLayout :
            switch UIDevice.modelName {
            case let device where DevicesFabrica.get(with: .allModels).contains(device) :
                var newAnchor: [FloatingPanelState : FloatingPanelLayoutAnchoring] {
                    return [
                        .half: FloatingPanelLayoutAnchor(fractionalInset: 0.45, edge: .bottom, referenceGuide: .superview ),
                    ]
                }
                return newAnchor
            default:
                var newAnchor: [FloatingPanelState : FloatingPanelLayoutAnchoring] {
                    return [
                        .half: FloatingPanelLayoutAnchor(fractionalInset: 0.4, edge: .bottom, referenceGuide: .superview  )
                    ]
                }
                return newAnchor
            }
        }
    }
}
