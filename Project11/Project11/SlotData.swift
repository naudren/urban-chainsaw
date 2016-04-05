//
//  SlotData.swift
//  Project11
//
//  Created by Nicolas Audren on 20/03/2016.
//  Copyright © 2016 Nicosoft. All rights reserved.
//

import UIKit

enum SlotType {
    case Good, Bad
    case Invalid
}

class SlotData: NSObject {
    var position : CGPoint
    var type : SlotType
    
    init(position : CGPoint, type: SlotType) {
        self.position = position
        self.type = type
    }
}
