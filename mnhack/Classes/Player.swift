//
//  Player.swift
//  mnhack
//
//  Created by Jason Rahaim on 6/16/20.
//  Copyright © 2020 jrdev. All rights reserved.
//

import Foundation

class Player: GameObject {
    var health = 0
    var maxHealth = 0
    
    init(position: Location2d, floor: Int) {
        super.init(position: position, floor: floor, type: .player, appearence: "@")
        self.health = 10
        self.maxHealth = self.health
    }
}
