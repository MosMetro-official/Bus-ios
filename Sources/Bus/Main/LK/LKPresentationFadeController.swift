//
//  LKPresentationFadeController.swift
//  Mosmetro
//
//  Created by Максим Филимонов on 30/06/2021.
//  Copyright © 2021 PPR. All rights reserved.
//

import UIKit

final class LKPresentationFadeController: UIPresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        return self.frameForPresentedController()
    }
    
    func frameForPresentedController() -> CGRect {
        guard let containerFrame = self.containerView?.frame else {
            return UIScreen.main.bounds
        }
        return containerFrame
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        containerView?.addSubview(presentedView!)
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
}
