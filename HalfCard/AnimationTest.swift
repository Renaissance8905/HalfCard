//
//  AnimationTest.swift
//  HalfCard
//
//  Created by Chris Spradling on 3/1/20.
//  Copyright © 2020 Chris Spradling. All rights reserved.
//

import UIKit

class PresenterVC: UIViewController {
    var interactor: UIPercentDrivenInteractiveTransition?

    lazy var cardView: TestCard = {
        let view = TestCard()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissCard))
        view.addGestureRecognizer(gesture)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(onPan))
        view.addGestureRecognizer(pan)
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = cardView

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cardView.setPercentPresented(0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cardView.animateIn()
    }
    
    @objc func dismissCard() {
        cardView.animateOut { _ in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
//    @objc private func onPan(_ gesture: UIPanGestureRecognizer) {
//
//        var percent: CGFloat = 1 - (gesture.translation(in: cardView).y / cardView.cardHeight)
//
//        if percent > 1 {
//            percent = sqrt(percent)
//        }
//
//        switch gesture.state {
//        case .began:
//            interactor = UIPercentDrivenInteractiveTransition()
//            dismiss(animated: true, completion: nil)
//        case .changed:
//            interactor?.update(percent)
//        case .ended:
//            let velocity = gesture.velocity(in: gesture.view)
//
//            if percent > 0.5 || velocity.y > 0 {
//                interactor?.finish()
//            } else {
//                interactor?.cancel()
//            }
//            interactor = nil
//        case .cancelled:
//            interactor?.cancel()
//            interactor = nil
//
//        default:
//            return
//        }
//    }
//
//    func animateOut() {
//        view.layoutIfNeeded()
//        UIView.animate(withDuration: 4) {
//            self.cardView.setPercentPresented(0)
//            self.cardView.layoutIfNeeded()
//        }

    @objc private func onPan(_ gesture: UIPanGestureRecognizer) {

        var percent: CGFloat = 1 - (gesture.translation(in: cardView).y / cardView.cardHeight)

        if percent > 1 {
            percent = sqrt(percent)
        }

        switch gesture.state {
        case .began:
            cardView.layer.removeAllAnimations()
        case .changed:
            cardView.setPercentPresented(percent)
        case .ended:
            if cardView.percentPresented < 0.7 {
                dismissCard()
            } else {
                cardView.animateIn()
            }

        case .cancelled:
            cardView.animateIn()
        default:
            return
        }

    }
}
