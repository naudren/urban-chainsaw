//
//  Bouncer.swift
//  Project11
//
//  Created by Nicolas Audren on 20/03/2016.
//  Copyright © 2016 Nicosoft. All rights reserved.
//

import UIKit

enum BouncerMovementDirection {
    case Left,Right,None
    
    func multiplier() -> CGFloat {
        switch self {
        case .Left:
            return -1
        case .Right:
            return 1
        default:
            return 0
        }
    }
}

class BouncerData: NSObject {
    var position : CGPoint
    var moveDistance: CGFloat
    var moveDirection: BouncerMovementDirection
    var moveDuration: CFTimeInterval
    
    
    init(position : CGPoint, moveByX distance:CGFloat, withDirection direction: BouncerMovementDirection, forDuration duration: CFTimeInterval) {
        self.position = position
        self.moveDistance = distance
        self.moveDirection = direction
        self.moveDuration = duration
    }
}
