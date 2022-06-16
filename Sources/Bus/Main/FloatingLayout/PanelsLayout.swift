//
//  AllPanelsLayout.swift
//  MosmetroNew
//
//  Created by Павел Кузин on 24.11.2020.
//  Copyright © 2020 Гусейн Римиханов. All rights reserved.
//
//

import UIKit
import FloatingPanel

class GuideFloatingLayout: FloatingPanelLayout {

    var initialState: FloatingPanelState    = .half
    var position    : FloatingPanelPosition = .bottom

    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        switch UIDevice.modelName {
        case "iPhone 5c", "iPhone 5s", "iPhone 6", "iPhone 6s", "iPhone 7", "iPhone SE", "iPhone 8", "iPod touch (6th generation)", "iPod touch (7th generation)":
            return [
                .half: FloatingPanelLayoutAnchor(fractionalInset: 0.45, edge: .bottom, referenceGuide: .superview)
            ]
        default:
            return [
                .half: FloatingPanelLayoutAnchor(fractionalInset: 0.4, edge: .bottom, referenceGuide: .superview)
            ]
        }
    }
}

class MenuFloatingLayout: FloatingPanelLayout {

    var initialState: FloatingPanelState    = {
        switch UIDevice.modelName {
        case "iPhone 5c", "iPhone 5s", "iPhone SE":
            return .tip
        default:
            return .half
        }
    } ()
    var position : FloatingPanelPosition = .bottom

    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        switch UIDevice.modelName {
        case "iPhone 5c", "iPhone 5s", "iPhone SE":
            return [
                .full: FloatingPanelLayoutAnchor(absoluteInset: 16,     edge: .top,    referenceGuide: .safeArea ),
                .half: FloatingPanelLayoutAnchor(fractionalInset: 0.55, edge: .bottom, referenceGuide: .superview),
                .tip: FloatingPanelLayoutAnchor(fractionalInset: 0.15,  edge: .bottom, referenceGuide: .safeArea )
            ]
        case "iPhone 6", "iPhone 6s", "iPhone 7", "iPhone 8", "iPod touch (6th generation)", "iPod touch (7th generation)":
            return [
                .full: FloatingPanelLayoutAnchor(absoluteInset: 16,     edge: .top,    referenceGuide: .safeArea ),
                .half: FloatingPanelLayoutAnchor(fractionalInset: 0.45, edge: .bottom, referenceGuide: .superview),
                .tip: FloatingPanelLayoutAnchor(fractionalInset: 0.12,  edge: .bottom, referenceGuide: .safeArea )
            ]
        default:
            return [
                .full: FloatingPanelLayoutAnchor(absoluteInset: 16,     edge: .top,    referenceGuide: .safeArea ),
                .half: FloatingPanelLayoutAnchor(fractionalInset: 0.35, edge: .bottom, referenceGuide: .superview),
                .tip: FloatingPanelLayoutAnchor(fractionalInset: 0.1,   edge: .bottom, referenceGuide: .safeArea )
            ]
        }
    }
}

class ParkingPanelLayout: FloatingPanelLayout {
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .half
    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        return [
            .half: FloatingPanelIntrinsicLayoutAnchor(absoluteOffset: 0, referenceGuide: .safeArea),
        ]
    }
}

class RefundPanelLayout: FloatingPanelLayout {
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .hidden
    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        return [
            .half: FloatingPanelIntrinsicLayoutAnchor(absoluteOffset: 0, referenceGuide: .superview),
        ]
    }
    
    func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
        return 0.1
    }
}
