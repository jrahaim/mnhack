//
//  Object.swift
//  mnhack
//
//  Created by Jason Rahaim on 6/16/20.
//  Copyright © 2020 jrdev. All rights reserved.
//

import SpriteKit
import GameplayKit

enum GameObjectType {
    case player
    case alive
    case loot
    case environment
}

class GameObject {
    var position: Location
    let type: GameObjectType
    let appearence: String
    
    init(position: Location, type: GameObjectType, appearence: String) {
        self.position = position
        self.type = type
        self.appearence = appearence
    }
}
