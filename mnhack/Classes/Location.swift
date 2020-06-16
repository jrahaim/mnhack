//
//  GameLocation.swift
//  mnhack
//
//  Created by Jason Rahaim on 6/16/20.
//  Copyright © 2020 jrdev. All rights reserved.
//

import Foundation

class Location {
    let floor: Int
    let x: Int
    let y: Int
    
    init(floor: Int, x: Int, y: Int) {
        self.floor = floor
        self.x = x
        self.y = y
    }
}
