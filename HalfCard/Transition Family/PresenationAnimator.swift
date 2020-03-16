//
//  PresenationAnimator.swift
//  HalfCard
//
//  Created by Chris Spradling on 3/3/20.
//  Copyright © 2020 Chris Spradling. All rights reserved.
//

import UIKit

class PresentationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    enum PresentationDirection {
        case present, dismiss
    }

    let direction: PresentationDirection

    var key: UITransitionContextViewControllerKey {
        direction == .present ? .to : .from
    }

    init(_ direction: PresentationDirection) {
        self.direction = direction
        super.init()
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        1
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let viewController = transitionContext.viewController(forKey: key),
            let card = viewController.view as? TestCard,
            let presenter = viewController.presentationController as? Presentationer
        else { return }

        switch direction {
        case .present:
            transitionContext.containerView.addSubview(card)
            presenter.setPercentPresented(0)
            presenter.animateToCard(transitionContext.completeTransition)

        case .dismiss:
            presenter.animateOut(transitionContext.completeTransition)
        }

    }

}


extension PresentationAnimator: UIViewControllerInteractiveTransitioning {
    
    var vcKey: UITransitionContextViewControllerKey {
        direction == .present ? .to : .from
    }

    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        let vc = transitionContext.viewController(forKey: vcKey)
        
        vc?.dismiss(animated: true, completion: {
            transitionContext.completeTransition(true)
        })

    }
    
    
}
