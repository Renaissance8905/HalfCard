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
