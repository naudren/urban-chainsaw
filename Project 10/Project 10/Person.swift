//
//  Person.swift
//  Project 10
//
//  Created by Nicolas Audren on 16/03/2016.
//  Copyright © 2016 Nicosoft. All rights reserved.
//

import UIKit

class Person: NSObject {
    var name : String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
