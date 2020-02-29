//
//  ViewController.swift
//  HalfCard
//
//  Created by Chris Spradling on 2/28/20.
//  Copyright © 2020 Chris Spradling. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view = UIView()
        view.backgroundColor = .gray
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        view.addGestureRecognizer(gesture)
        
    }
    
    @objc private func onTap() {
        let vc = PresenterVC()
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: false, completion: nil)
    }

}

class PresenterVC: UIViewController {
    
    lazy var animateIn = UIViewPropertyAnimator(duration: 1, curve: .easeOut) {
        self.cardView.setPercentPresented(1)
        self.cardView.layoutIfNeeded()
    }
    
    lazy var animateOut = UIViewPropertyAnimator(duration: 1, curve: .easeOut) {
        self.cardView.setPercentPresented(0)
        self.cardView.layoutIfNeeded()
    }
    
    let cardView = TestCard()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = cardView
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissCard))
        cardView.addGestureRecognizer(gesture)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(onPan))
        view.addGestureRecognizer(pan)

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

class TestCard: UIView {
    
    let cardHeight: CGFloat = 500
    let topperHeight: CGFloat = 166
    
    private weak var cardHeightConstraint: NSLayoutConstraint?
    
    init() {
        super.init(frame: .zero)
        
        installConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func installConstraints() {
        
        let gap: CGFloat = 12
        
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        addSubview(card)
        card.addSubview(topper)
        
        card.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -gap * 2).isActive = true
        card.leadingAnchor.constraint(equalTo: leadingAnchor, constant: gap).isActive = true
        card.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -gap).isActive = true
        card.layer.cornerRadius = 36
        cardHeightConstraint = card.heightAnchor.constraint(equalToConstant: cardHeight)
        cardHeightConstraint?.isActive = true
        
        topper.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8).isActive = true
        topper.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        topper.centerYAnchor.constraint(equalTo: card.topAnchor, constant: 10).isActive = true
        topper.heightAnchor.constraint(equalToConstant: topperHeight).isActive = true
        
    }
    
    func installTail() {
        card.addSubview(tail)

        tail.topAnchor.constraint(equalTo: card.bottomAnchor).isActive = true
        tail.leadingAnchor.constraint(equalTo: card.leadingAnchor).isActive = true
        tail.trailingAnchor.constraint(equalTo: card.trailingAnchor).isActive = true
        tail.heightAnchor.constraint(equalToConstant: cardHeight).isActive = true
    }
    
    let card: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()

    let tail: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    let topper: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .blue
        view.layer.cornerRadius = 12
        return view
    }()
    
    var percentPresented: CGFloat = 0
    
    func setPercentPresented(_ percent: CGFloat) {
        percentPresented = percent
        let invertPercent = 1 - percent
        
        card.transform = CGAffineTransform(translationX: 0, y: cardHeight * max(0, invertPercent))
        cardHeightConstraint?.constant = cardHeight * max(1, percent)
        topper.transform = CGAffineTransform(translationX: 0, y: (topperHeight / 2) * invertPercent)
        backgroundColor = UIColor.black.withAlphaComponent(percent * 0.5)
        
    }
    
    func animateIn(_ completion: ((Bool) -> Void)? = nil) {
        layoutIfNeeded()
        
        let animations: () -> Void = {
            self.setPercentPresented(1)
            self.layoutIfNeeded()
        }
        
        
        
        UIView.animate(withDuration: 0.7,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.2,
                       options: .curveEaseOut,
                       animations: animations,
                       completion: completion)
        
    }

    func animateOut(_ completion: ((Bool) -> Void)? = nil) {
        layoutIfNeeded()
        UIView.animate(withDuration: 0.5 * Double(percentPresented), animations: {
            self.setPercentPresented(0)
            self.layoutIfNeeded()
        }, completion: completion)
    }
}



class Presenter: UIPresentationController {
    
}

class TransitionDelegate: UIPercentDrivenInteractiveTransition {
    
}


