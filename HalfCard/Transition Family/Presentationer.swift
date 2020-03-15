//
//  Presentationer.swift
//  HalfCard
//
//  Created by Chris Spradling on 3/3/20.
//  Copyright © 2020 Chris Spradling. All rights reserved.
//

import UIKit

class Presentationer: UIPresentationController {
    
    private let cardType: CardType = .floating
    private let cardHeight: CardHeight = .half

    private weak var cardView: TestCard?
    
    private lazy var blurEffectView: UIVisualEffectView = {
        let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
       
        blurEffectView.isUserInteractionEnabled = true
        let tapToDismiss = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        blurEffectView.addGestureRecognizer(tapToDismiss)
        
        return blurEffectView
    }()

    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        cardView = presentedViewController.view as? TestCard
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)

        let pan = UIPanGestureRecognizer(target: self, action: #selector(onPan))
        cardView?.addGestureRecognizer(pan)

    }

    @objc private func onPan(_ gesture: UIPanGestureRecognizer) {
        guard let cardView = gesture.view as? TestCard else { return }

        var percent: CGFloat = 1 - (gesture.translation(in: cardView).y / cardView.cardHeight)

        if percent > 1 {
            percent = sqrt(percent)
        }

        switch gesture.state {
        case .began:
            cardView.layer.removeAllAnimations()
        case .changed:
            cardView.setPercentPresented(percent)
            blurEffectView.alpha = percent
        case .ended:
            if cardView.percentPresented < 0.7 && gesture.velocity(in: cardView).y >= 0 {
                dismiss()
            } else {
                cardView.animateIn()
            }

        case .cancelled:
            cardView.animateIn()
        default:
            return
        }

    }

    @objc private func dismiss() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let container = containerView?.frame else {
            return .zero
        }
                
        return CGRect(x: cardType.gap,
                      y: cardHeight.originY(in: container),
                      width: container.width - (cardType.gap * 2),
                      height: cardHeight.height(in: container) - cardType.bottomGap)
    }
    
    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.blurEffectView.alpha = 0
        }, completion: { _ in
            self.blurEffectView.removeFromSuperview()
        })
    }
    
    override func presentationTransitionWillBegin() {
        blurEffectView.alpha = 0
        containerView?.addSubview(blurEffectView)
        cardView?.setPercentPresented(0)
        
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.blurEffectView.alpha = 1
            self.cardView?.setPercentPresented(1)
        }, completion: nil)
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        presentedView!.layer.cornerRadius = cardType.cornerRadius
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        self.presentedView?.frame = frameOfPresentedViewInContainerView
        blurEffectView.frame = containerView!.bounds
    }
}

