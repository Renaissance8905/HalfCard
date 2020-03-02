//
//  HalfCard.swift
//  HalfCard
//
//  Created by Chris Spradling on 3/1/20.
//  Copyright © 2020 Chris Spradling. All rights reserved.
//

import UIKit

class TestCard: UIView, InteractiveModalCard {
    
    let cardHeight: CGFloat = 400
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
        
        backgroundColor = .white
        addSubview(topper)
        
        cardHeightConstraint = heightAnchor.constraint(equalToConstant: cardHeight)
        cardHeightConstraint?.isActive = true
        
        topper.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8).isActive = true
        topper.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        topper.centerYAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        topper.heightAnchor.constraint(equalToConstant: topperHeight).isActive = true
        
    }
    
    func installTail(on card: UIView) {
        
        card.addSubview(tail)

        tail.topAnchor.constraint(equalTo: card.bottomAnchor).isActive = true
        tail.leadingAnchor.constraint(equalTo: card.leadingAnchor).isActive = true
        tail.trailingAnchor.constraint(equalTo: card.trailingAnchor).isActive = true
        tail.heightAnchor.constraint(equalToConstant: cardHeight).isActive = true
        
    }

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
        
        transform = CGAffineTransform(translationX: 0, y: cardHeight * max(0, invertPercent))
        cardHeightConstraint?.constant = cardHeight * max(1, percent)
        topper.transform = CGAffineTransform(translationX: 0, y: topperHeight / 2 * invertPercent)
        
    }
    
    func animateIn(_ completion: ((Bool) -> Void)? = nil) {
        
        let animations: () -> Void = {
            self.setPercentPresented(1)
            self.layoutIfNeeded()
        }
        
        layoutIfNeeded()
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
            self.layoutIfNeeded()
        }
        
        layoutIfNeeded()
        UIView.animate(withDuration: 0.5 * Double(percentPresented),
                       animations: animations,
                       completion: completion)
        
    }
    
}
