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

    private weak var cardView: CardView?
    
    private lazy var blurEffectView: UIVisualEffectView = {
        let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
       
        blurEffectView.isUserInteractionEnabled = true
        let tapToDismiss = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        blurEffectView.addGestureRecognizer(tapToDismiss)
        
        return blurEffectView
    }()

    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        cardView = presentedViewController.view as? CardView
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)

        let pan = UIPanGestureRecognizer(target: self, action: #selector(onPan))
        cardView?.addGestureRecognizer(pan)

    }

    var open = false

    @objc private func onPan(_ gesture: UIPanGestureRecognizer) {
        guard let cardView = gesture.view as? TestCard else { return }

        let percent = gesture.percentY(in: cardView, isCardOpen: open)

        switch gesture.state {
        case .began:
            cardView.layer.removeAllAnimations()
        case .changed:
            setPercentPresented(percent)
            blurEffectView.alpha = percent
        case .ended:

            let nearestRestingPoint = CardDisplayMode.nearest(to: percent)
            let snapDirection = gesture.snapTo(in: cardView)
            let isDown = gesture.isDown(in: cardView)

            let shouldOpen = snapDirection == .up || (nearestRestingPoint == .full && !isDown)
            let shouldClose = snapDirection == .down || (nearestRestingPoint == .closed && isDown)

            if shouldOpen || percent > 2 {
                animateToOpen()
                open = true
            } else {
                shouldClose ? dismiss() : animateToCard()
                open = false
            }

        case .cancelled:
            animateToCard()
        default:
            return
        }

    }

    private var percentPresented: CGFloat = 0

    func setPercentPresented(_ percent: CGFloat) {
        percentPresented = percent
        guard let cardView = cardView else { return }
        
        let threshold: CGFloat = 1.5

        let overage = max(0, (percent - threshold) * 2)

        cardView.layer.cornerRadius = cardType.cornerRadius * (1 - overage)

        let rangeX = ((cardView.frame.width + cardType.gap * 2) / cardView.frame.width) + 0.01
        let pctDeltaX = ((rangeX - 1) * overage) + 1
        let deltaX = max(1, min(pctDeltaX, rangeX))

        let gapDrop = cardType.bottomGap * overage

        let invertPercent = 1 - percent

        let scaleTransform = cardView.positiveStretchTransform(dX: deltaX, dY: percent)
        let invertedScaleTransform = scaleTransform.inverted()

        let variantSlide = percent > 1 ? min(0, 1 + ((-1 - percent) / 2)) : max(0, invertPercent)
        let positionTransform = CGAffineTransform(translationX: 0, y: (cardView.cardHeight * variantSlide) + gapDrop)
        cardView.transform = scaleTransform.concatenating(positionTransform)
        cardView.subviews.forEach { $0.transform = invertedScaleTransform }

        cardView.setPercentPresented(percent)
    }

    func animateToOpen(_ completion: ((Bool) -> Void)? = nil) {

        let animations: () -> Void = {
            self.setPercentPresented(2)
            self.blurEffectView.alpha = 1
            self.cardView?.layoutIfNeeded()
        }

        cardView?.layoutIfNeeded()
        UIView.animate(withDuration: 0.35 * Double(2 - percentPresented),
                       animations: animations,
                       completion: completion)

    }

    func animateToCard(_ completion: ((Bool) -> Void)? = nil) {

        let animations: () -> Void = {
            self.setPercentPresented(1)
            self.blurEffectView.alpha = 1
            self.cardView?.layoutIfNeeded()
        }

        cardView?.layoutIfNeeded()
        UIView.animate(withDuration: 0.7,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.2,
                       options: .curveEaseOut,
                       animations: animations,
                       completion: completion)

    }

    func animateOut(_ completion: ((Bool) -> Void)? = nil) {

        let animations: () -> Void = {
            self.setPercentPresented(-0.1)
            self.blurEffectView.alpha = 0
            self.cardView?.layoutIfNeeded()
        }

        cardView?.layoutIfNeeded()
        UIView.animate(withDuration: 0.35 * Double(percentPresented),
                       animations: animations,
                       completion: completion)

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

func po(_ thing: Any, as id: String) {
    print("@@ \(id): \(thing)")
}
