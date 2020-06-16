//
//  Floor.swift
//  mnhack
//
//  Created by Jason Rahaim on 6/16/20.
//  Copyright © 2020 jrdev. All rights reserved.
//

import Foundation

enum FloorType {
    case normal
}

class Floor {
    var objects = [GameObject]()
    
    init(type: FloorType?) {
        // TODO: Draw Walls
    }
    
    func wall(at location: Location2d) -> Bool {
        let occupied = objects(at: location)
        return occupied.reduce(false) { (result, object) -> Bool in
            return object.type == .wall || result
        }
    }
    
    func closedDoor(at location: Location2d) -> Bool {
        let occupied = objects(at: location)
        return occupied.reduce(false) { (result, object) -> Bool in
            return object.type == .doorClosed || result
        }
    }
    
    func opendDoor(at location: Location2d) -> Bool {
        let occupied = objects(at: location)
        return occupied.reduce(false) { (result, object) -> Bool in
            return object.type == .doorOpen || result
        }
    }
    
    func lockedDoor(at location: Location2d) -> Bool {
        let occupied = objects(at: location)
        return occupied.reduce(false) { (result, object) -> Bool in
            return object.type == .doorLocked || result
        }
    }
    
    func pathBlocked(at location: Location2d) -> Bool {
        let occupied = objects(at: location)
        return occupied.reduce(false) { (result, object) -> Bool in
            return object.blocksPath() || result
        }
    }
    
    func objects(at location: Location2d) -> [GameObject] {
        let result = objects.filter { (object) -> Bool in
            object.position == location
        }
        return result
    }
}
