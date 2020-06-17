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


typealias Ray = [Location2d]
typealias Starburst = [Ray]

class PossiblyVisiblePoints {
    // distance 1: [(-1,-1)], [(-1, 0)], [(-1,1)], [(0,1)], [(1,1)], [(1,0)], [(1,-1)], [(0,-1)];
    // Distance 1: 8 = 45
    // Distance 2: 16 = 22.5
    // Distance 3: 24 = 15
    // Distance 4: 32 = 11.25
    
    static func rays(distance: Int) -> Starburst {
        // a Ray is an array of points in a straight ine closest to furthest.
        // This function builds and array of rays that covers every point within a
        // given distance
        guard distance > 1 else {
            return Starburst()
        }
        
        let steps = distance * 8
        let stepSize = (Double.pi * 2) / Double(steps)
        var result = Starburst()
        for i in (0..<steps) {
            var ray = Ray()
            for d in (1...distance) {
                let x = Int(round(Double(d) * sin(stepSize * Double(i))))
                let y = Int(round(Double(d) * cos(stepSize * Double(i))))
                ray.append(Location2d(x: x, y: y))
            }
            result.append(ray)
        }
        return result
    }
}

class Location2d: Equatable, Hashable {
    let x: Int
    let y: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    static func == (lhs: Location2d, rhs: Location2d) -> Bool {
        return (lhs.x == rhs.x) && (lhs.y == rhs.y)
    }
    
    static func + (lhs: Location2d, rhs: Location2d) -> Location2d {
        return Location2d(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
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
