//
//  LKFadeDismissAnimator.swift
//  Mosmetro
//
//  Created by Максим Филимонов on 30/06/2021.
//  Copyright © 2021 PPR. All rights reserved.
//

import UIKit

final class LKFadeDismissAnimator: NSObject {
    let duration: TimeInterval = 0.25
    
    private func animator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        let fromController = transitionContext.view(forKey: .from)!
        
        let animator = UIViewPropertyAnimator(duration: duration, curve: .easeOut) {
            fromController.alpha = 0
        }
        
        animator.addCompletion { (position) in
            fromController.alpha = 0
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
        return animator
    }
}

extension LKFadeDismissAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let animator = self.animator(using: transitionContext)
        animator.startAnimation()
    }
    
    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        return self.animator(using: transitionContext)
    }
}
