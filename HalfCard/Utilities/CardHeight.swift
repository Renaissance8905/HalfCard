//
//  CardHeight.swift
//  HalfCard
//
//  Created by Chris Spradling on 3/3/20.
//  Copyright © 2020 Chris Spradling. All rights reserved.
//

import UIKit

enum CardHeight {
    case height(CGFloat)
    case percent(CGFloat)
    
    func originY(in container: CGRect) -> CGFloat {
        switch self {
        case .percent(let pct):
            return container.height * (1 - pct)
        case .height(let height):
            return container.height - height
        }
    }
    
    func height(in container: CGRect) -> CGFloat {
        switch self {
        case .percent(let pct):
            return container.height * pct
        case .height(let height):
            return height
        }
    }
    
    static var half: Self {
        .percent(0.5)
    }
    
    static var oneThird: Self {
        .percent(1/3)
    }
    
    static var twoThirds: Self {
        .percent(2/3)
    }
    
}


extension UIView {

    func positiveStretchTransform(dX: CGFloat? = nil, dY: CGFloat? = nil) -> CGAffineTransform {
        CGAffineTransform(scaleX: stretchFactor(dX, for: frame.width),
                          y: stretchFactor(dY, for: frame.height))
    }

    private func stretchFactor(_ percent: CGFloat?, for ref: CGFloat) -> CGFloat {
        guard let percent = percent else { return 1 }
        return max(1, ceil(ref * percent) / ref)
    }

}

extension CGFloat {

    func normalized(on ref: CGFloat) -> CGFloat {
        ceil(self * ref) / ref
    }

    func tapered(after baseline: CGFloat) -> CGFloat {
        self <= baseline ? self : sqrt(self - baseline) + baseline
    }

    mutating func taper(after baseline: CGFloat) {
        self = tapered(after: baseline)
    }
}

extension UIPanGestureRecognizer {

    enum SnapDirection {
        case up, down, none
    }

    func snapTo(in view: UIView) -> SnapDirection {
        let v = velocity(in: view).y
        if v > 1500 { return .down }
        if v < -1500 { return .up }
        return .none
    }

    func isDown(in view: UIView) -> Bool {
        velocity(in: view).y >= 0
    }

    func percentY(in cardView: CardView, isCardOpen: Bool) -> CGFloat {
        var percent: CGFloat = 1 - (translation(in: cardView).y / cardView.cardHeight)
        percent *= (isCardOpen ? 2 : 1)
        return percent.tapered(after: 2)

    }

}
