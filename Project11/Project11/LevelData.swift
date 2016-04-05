//
//  LevelData.swift
//  Project11
//
//  Created by Nicolas Audren on 20/03/2016.
//  Copyright © 2016 Nicosoft. All rights reserved.
//

import UIKit

class LevelData: NSObject {
    let startingBalls: Int
    let scoreNeededToClear : Int
    let scorePerBall : Int
    var slots = [SlotData]()
    var bouncers = [BouncerData]()
    
    init(fromJSON data: JSON) {
        startingBalls = data["startingBalls"].numberValue as Int
        scoreNeededToClear = data["scoreNeeded"].numberValue as Int
        scorePerBall = data["scorePerBall"].numberValue as Int
        super.init()
        parseSlots(fromJSON: data)
        parseBouncers(fromJSON: data)
    }
    
    func parseSlots(fromJSON data: JSON) {
        let levelSlots = data["slots"]
        
        for slot in levelSlots.arrayValue {
            let x = slot["x"].numberValue as CGFloat
            let y = slot["y"].numberValue as CGFloat
            let name = slot["name"].stringValue
            var type : SlotType
            switch name {
            case "good":
                type = .Good
            case "bad":
                type = .Bad
            default:
                type = .Invalid
            }
            
            let slotData = SlotData(position: CGPoint(x: x, y: y), type: type)
            slots.append(slotData)
        }
    }
    
    func parseBouncers(fromJSON data: JSON) {
        let levelBouncers = data["bouncers"]
        
        for bouncer in levelBouncers.arrayValue {
            let x = bouncer["x"].numberValue as CGFloat
            let y = bouncer["y"].numberValue as CGFloat
            let moveDirectionString = bouncer["moveDirection"].stringValue
            var moveDirection : BouncerMovementDirection
            switch moveDirectionString {
            case "Left":
                moveDirection = .Left
            case "Right":
                moveDirection = .Right
            case "None":
                fallthrough
            default:
                moveDirection = .None
                
            }
            let moveDuration = bouncer["moveDuration"].numberValue as CFTimeInterval
            let moveDistance = bouncer["moveDistance"].numberValue as CGFloat
            
            
            let bouncerData = BouncerData(position: CGPoint(x: x, y: y), moveByX: moveDistance, withDirection: moveDirection, forDuration: moveDuration)
            
            bouncers.append(bouncerData)
        }
    }
}
