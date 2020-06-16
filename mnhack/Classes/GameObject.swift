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
    case doorOpen
    case doorClosed
    case doorLocked
    case wall
}

class GameObject {
    var position: Location2d
    var floor: Int
    let type: GameObjectType
    let appearence: String
    
    init(position: Location2d, floor: Int, type: GameObjectType, appearence: String) {
        self.floor = floor
        self.position = position
        self.type = type
        self.appearence = appearence
    }
    
    func blocksPath() -> Bool {
        return self.type == .alive ||
            self.type == .doorClosed ||
            self.type == .doorLocked ||
            self.type == .wall
    }
}
