//
//  GameLocation.swift
//  mnhack
//
//  Created by Jason Rahaim on 6/16/20.
//  Copyright © 2020 jrdev. All rights reserved.
//

import Foundation

enum Direction {
    case north
    case south
    case east
    case west
}

class Location2d: Equatable {
    let x: Int
    let y: Int
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    static func == (lhs: Location2d, rhs: Location2d) -> Bool {
        return (lhs.x == rhs.x) && (lhs.y == rhs.y)
    }
    
    func pos(_ direction: Direction) -> Location2d {
        var x = self.x
        var y = self.y
        
        switch direction {
        case .north:
            y = y + 1
        case .south:
            y = y - 1
        case .east:
            x = x + 1
        case .west:
            x = x - 1
        }
        
        return Location2d(x: x, y: y)
    }
}
