//
//  TransitionCoordinator.swift
//  HalfCard
//
//  Created by Chris Spradling on 3/3/20.
//  Copyright © 2020 Chris Spradling. All rights reserved.
//

import UIKit

class TransitionCoordinator: NSObject, UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        Presentationer(presentedViewController: presented, presenting: presenting)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        PresentationAnimator(.present)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        PresentationAnimator(.dismiss)
    }
//    
//    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
//        PresentationAnimator(.dismiss)
//    }
    
}
