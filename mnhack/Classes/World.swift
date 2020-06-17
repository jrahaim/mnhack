//
//  World.swift
//  mnhack
//
//  Created by Jason Rahaim on 6/16/20.
//  Copyright © 2020 jrdev. All rights reserved.
//

import Foundation

class World {
    static let shared = World()
    let player: Player
    var floors = [Floor]()
    var visibilityMap = [Starburst]() // Array holding rays for given distances.
    
    private init() {
        let firstFloor = Floor(type: .normal)
        floors.append(firstFloor)
        // this startung position needs to be based on the floor's stairs up.
        self.player = Player(position: firstFloor.stairsUp ?? Location2d(x:20, y:20), floor: 0)
        for distance in (0...10) {
            visibilityMap.append(PossiblyVisiblePoints.rays(distance: distance))
        }
    }
    
    func floor(_ floorNumber: Int) -> Floor {
        while floorNumber > floors.count {
            // create a new floor(s)
            floors.append(Floor(type: .normal))
        }
        return floors[floorNumber]
    }
    
    func object(floor floorNumber: Int, location: Location2d) -> [GameObject] {
        let aFloor = floor(floorNumber)
        
        return aFloor.objects(at: location)
    }
    
    func pathBlocked(floor floorNumber: Int, location: Location2d) -> Bool {
        let aFloor = floor(floorNumber)
        return aFloor.pathBlocked(at: location)
    }
    
}
