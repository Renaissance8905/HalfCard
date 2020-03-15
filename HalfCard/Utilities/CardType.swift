//
//  CardType.swift
//  HalfCard
//
//  Created by Chris Spradling on 3/3/20.
//  Copyright © 2020 Chris Spradling. All rights reserved.
//

import UIKit

enum CardType {
    case floating
    case attached
    
    var cornerRadius: CGFloat {
        self == .floating ? 36 : 0
    }
    
    var gap: CGFloat {
        self == .floating ? 16 : 0
    }
    
    var bottomGap: CGFloat {
        // special allowance for the home bar
        self == .floating ? max(gap, 24) : 0
    }
    
}
