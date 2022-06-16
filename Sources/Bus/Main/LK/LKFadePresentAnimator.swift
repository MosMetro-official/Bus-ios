//
//  LKFadePresentAnimator.swift
//  Mosmetro
//
//  Created by Максим Филимонов on 30/06/2021.
//  Copyright © 2021 PPR. All rights reserved.
//

import UIKit

final class LKFadePresentAnimator: NSObject {
    
    let duration: TimeInterval = 0.25
    
    private func animator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        let finalFrame = transitionContext.finalFrame(for: transitionContext.viewController(forKey: .from)!)
        let toController = transitionContext.view(forKey: .to)!
        toController.alpha = 0
        toController.frame = finalFrame
        let animator = UIViewPropertyAnimator(duration: duration, curve: .easeOut) {
            toController.alpha = 1
        }
        animator.addCompletion { (position) in
            toController.alpha = 1
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        return animator
    }
}

extension LKFadePresentAnimator: UIViewControllerAnimatedTransitioning {
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let animator = self.animator(using: transitionContext)
        animator.startAnimation()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        return self.animator(using: transitionContext)
    }
}
