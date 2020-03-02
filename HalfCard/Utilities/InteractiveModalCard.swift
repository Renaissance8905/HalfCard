//
//  InteractiveModalCard.swift
//  HalfCard
//
//  Created by Chris Spradling on 3/3/20.
//  Copyright © 2020 Chris Spradling. All rights reserved.
//

import UIKit

protocol InteractiveModalCard where Self: UIView {
    var cardHeight: CGFloat { get }
//    var percentPresented: CGFloat { get }
    
    func setPercentPresented(_: CGFloat)
    func animateIn(_ completion: ((Bool) -> Void)?)
    func animateOut(_ completion: ((Bool) -> Void)?)
}
