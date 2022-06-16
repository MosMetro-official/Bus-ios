//
//  LKFadeTransition.swift
//  Mosmetro
//
//  Created by Максим Филимонов on 30/06/2021.
//  Copyright © 2021 PPR. All rights reserved.
//

import UIKit

final class LKFadeTransition: NSObject, UIViewControllerTransitioningDelegate {
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return LKFadeDismissAnimator()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = LKPresentationFadeController(
            presentedViewController: presented,
            presenting: presenting ?? source)
        return presentationController
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return LKFadePresentAnimator()
    }
}
