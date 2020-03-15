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

        topper.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8).isActive = true
        topper.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        topper.centerYAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        topper.heightAnchor.constraint(equalToConstant: topperHeight).isActive = true

        addSubview(testText)
        testText.translatesAutoresizingMaskIntoConstraints = false
        testText.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        testText.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        testText.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8).isActive = true
    }
    
    func installTail(on card: UIView) {
        
        card.addSubview(tail)

        tail.topAnchor.constraint(equalTo: card.bottomAnchor).isActive = true
        tail.leadingAnchor.constraint(equalTo: card.leadingAnchor).isActive = true
        tail.trailingAnchor.constraint(equalTo: card.trailingAnchor).isActive = true
        tail.heightAnchor.constraint(equalToConstant: cardHeight).isActive = true
        
    }

    let testText: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.textColor = .brown
        label.text = "This is some test text. What I'm hoping it will do is float at roughly the current center of the card view, and most importantly, not stretch or get wonky when the view stretches at >100% scenarios. Let's see how we do."
        return label
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

        let scaleTransform = positiveStretchTransform(dY: percent)
        let invertedScaleTransform = scaleTransform.inverted()

        let variantSlide = percent > 1 ? min(0, 1 + ((-1 - percent) / 2)) : max(0, invertPercent)
        let positionTransform = CGAffineTransform(translationX: 0, y: cardHeight * variantSlide)
        transform = scaleTransform.concatenating(positionTransform)
        subviews.forEach { $0.transform = invertedScaleTransform }

        topper.transform = CGAffineTransform(translationX: 0, y: topperHeight / 2 * invertPercent).concatenating(invertedScaleTransform)

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
