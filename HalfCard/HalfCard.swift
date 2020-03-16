//
//  HalfCard.swift
//  HalfCard
//
//  Created by Chris Spradling on 3/1/20.
//  Copyright © 2020 Chris Spradling. All rights reserved.
//

import UIKit

enum CardDisplayMode {
    case closed, card, full

    static func nearest(to percent: CGFloat) -> CardDisplayMode {
        if percent > 1.2 { return full }
        if percent < 0.7 { return closed }
        return card
    }
}

protocol CardView where Self: UIView {
    var displayMode: CardDisplayMode { get set }
    var cardHeight: CGFloat { get }

    func setPercentPresented(_: CGFloat)
}

class TestCard: UIView, CardView {

    var displayMode: CardDisplayMode = .closed
    
    let cardHeight: CGFloat = 400
    private let topperHeight: CGFloat = 166

    init() {
        super.init(frame: .zero)
        
        installConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func installConstraints() {

        backgroundColor = .black
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

    let contentView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()

    let testText: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.textColor = .brown
        label.text = "This is some test text. What I'm hoping it will do is float at roughly the current center of the card view, and most importantly, not stretch or get wonky when the view stretches at >100% scenarios. Let's see how we do."
        return label
    }()

    let topper: UIView = {
        let view = UIImageView(image: UIImage(named: "splash"))
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()

    func setPercentPresented(_ percent: CGFloat) {
        let percent = min(2, percent)
        let threshold: CGFloat = 1.5
        let overage = max(0, (percent - threshold) * 2)

        let multiplier: CGFloat = 1.5 - (overage * 1.8)
        let factor = min((1 - percent) * multiplier, 1)
        let translation = CGAffineTransform(translationX: 0,
                                            y: topperHeight / 2 * factor)

        topper.layer.cornerRadius = 12 * (1 - overage)

        let range = (superview ?? self).frame.width / topper.frame.width
        let pctDelta = ((range - 1) * overage) + 1
        let delta = max(1, min(pctDelta, range))

        let scaleTransform = topper.positiveStretchTransform(dX: delta, dY: delta)

        topper.transform =
            translation
            .concatenating(scaleTransform)
            .concatenating(topper.transform)

    }

}
