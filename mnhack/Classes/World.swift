//
//  World.swift
//  mnhack
//
//  Created by Jason Rahaim on 6/16/20.
//  Copyright © 2020 jrdev. All rights reserved.
//

import Foundation

class World {
    let player: GameObject
    var floors = [Floor]()
    
    init() {
        floors[0]=(Floor(type: .normal))
        self.player = GameObject(position: Location(floor: 0, x:20, y:20), type: .player, appearence: "@")
        
    }
}
