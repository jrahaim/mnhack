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
    var structures = [Location2d: BuildingStructure]()
    var floorSize = CGSize(width: 32, height: 32) // Default floor size
    var stairsUp: Location2d?
    var stairsDown: Location2d?
    
    init(type: FloorType?) {
        createRandomRooms()
    }
}

extension Floor {
    // Rooms
    func createRandomRooms() {
        let numberOfRooms = Int(arc4random_uniform(UInt32(5))) + 9
        var roomRectangles = [CGRect]()
        
        for _ in (1...numberOfRooms) {
            let rect = roomRect()
            roomRectangles.append(rect)
        }
        
        buildHallways(between: roomRectangles)
        buildWalls(for: roomRectangles)
        buildFloors(for: roomRectangles)
        
        // Add Stairs up to the center of the first room
        if let rectangle = roomRectangles.first {
            let centerOfRoom = Location2d(x: Int(rectangle.midX), y: Int(rectangle.midY))
            self.stairsUp = centerOfRoom
            self.structures[centerOfRoom] = BuildingStructure(type: .stairsUp)
        }
    
        // Add Stairs down to the center of the last room
        if let rectangle = roomRectangles.last {
            let centerOfRoom = Location2d(x: Int(rectangle.midX), y: Int(rectangle.midY))
            self.stairsDown = centerOfRoom
            self.structures[centerOfRoom] = BuildingStructure(type: .stairsDown)
        }
        
        // And Lastly Doors
        buildDoors()
    }
    
    func roomRect() -> CGRect {
        var xPos = Int(arc4random_uniform(UInt32(floorSize.width - 5)))
        var yPos = Int(arc4random_uniform(UInt32(floorSize.height - 5)))
        
        let width = Int(arc4random_uniform(UInt32(5)))+4
        let height = Int(arc4random_uniform(UInt32(5)))+4
        
        if (xPos+width>=Int(floorSize.width)) {
            xPos = (Int(floorSize.width) - 1) - width;
        }
        if (yPos+height>=Int(floorSize.height)) {
            yPos = (Int(floorSize.height) - 1) - height;
        }
        
        let result = CGRect(x: xPos, y: yPos, width: width, height: height)
        
        return result
    }
    
    func buildHallways(between rooms: [CGRect]) {
        var previousRoom : CGRect?
        for room in rooms {
            if let previousRoom = previousRoom {
                if Int(arc4random_uniform(UInt32(2)))==1 {
                    hLine(x1: Int(previousRoom.midX), x2: Int(room.midX), y: Int(previousRoom.midY))
                    vLine(y1: Int(previousRoom.midY), y2: Int(room.midY), x: Int(room.midX))
                } else {
                    vLine(y1: Int(previousRoom.midY), y2: Int(room.midY), x: Int(previousRoom.midX))
                    hLine(x1: Int(previousRoom.midX), x2: Int(room.midX), y: Int(room.midY))
                }
            }
            previousRoom = room
        }
    }
    
    func buildWalls(for rooms:[CGRect]) {
        for room in rooms {
            buildWall(for: room)
        }
    }
    
    func buildWall(for room: CGRect) {
        for row in Int(room.minX)...Int(room.maxX) {
            wallIfEmpty(x: row, y: Int(room.minY))
            wallIfEmpty(x: row, y: Int(room.maxY))
        }
        for column in Int(room.minY)...Int(room.maxY) {
            wallIfEmpty(x: Int(room.minX), y: column)
            wallIfEmpty(x: Int(room.maxX), y: column)
        }
    }
    
    func buildFloors(for rooms: [CGRect]) {
        for room in rooms {
            buildFloor(for: room)
        }
    }
    
    func buildFloor(for room:CGRect) {
        for row in Int(room.minX+1)...Int(room.maxX-1) {
            for column in Int(room.minY+1)...Int(room.maxY-1) {
                structures[Location2d(x: row, y: column)] = BuildingStructure(type: .floor)
            }
        }
    }
    
    func buildDoors() {
        // Note, Our hallways purposfully go through walls. We'll now fill those spots with doors.
        for row in 1...Int(floorSize.width-1) {
            for column in 1...Int(floorSize.height-1) {
                let pos = Location2d(x: row, y: column)
                if (structures[pos]?.type == .floor) || structures[pos]?.type == .hall {
                    let wallsOnSides = ((structures[pos.pos(.east)]?.type == .wall) && (structures[pos.pos(.west)]?.type == .wall))
                    let wallsOnTopBottom = (structures[pos.pos(.north)]?.type == .wall) && (structures[pos.pos(.south)]?.type == .wall)
                    
                    if ( wallsOnSides || wallsOnTopBottom) {
                        structures[pos] = BuildingStructure(type: .doorClosed)
                    }
                }
            }
        }
    }
    
    func wallIfEmpty(x: Int, y: Int) {
        tileIfEmpty(x: x, y: y, tile: .wall)
    }
    
    func tileIfEmpty(x: Int, y: Int, tile: BuildingStructureType) {
        // Only place this sturcture if the current space is empty
        let pos = Location2d(x: x, y: y)
        guard structures[pos] == nil else {
            return
        }
        structures[pos] = BuildingStructure(type: tile)
    }
    
    
    func hLine(x1: Int, x2: Int, y : Int) {
        if (x1<x2) {
            for row in x1...x2 {
                structures[Location2d(x:row, y: y)] = BuildingStructure(type: .hall)
            }
        } else {
            for row in x2...x1 {
                structures[Location2d(x:row, y: y)] = BuildingStructure(type: .hall)
            }
        }
    }
    
    func vLine(y1: Int, y2: Int, x : Int) {
        if (y1<y2) {
            for column in y1...y2 {
                structures[Location2d(x:x, y: column)] = BuildingStructure(type: .hall)
            }
        } else {
            for column in y2...y1 {
                structures[Location2d(x:x, y: column)] = BuildingStructure(type: .hall)
            }
        }
    }
}

extension Floor {
    func wall(at location: Location2d) -> Bool {
        guard let furnishing = structures[location] else {
            return true
        }
        return furnishing.type == .wall
    }
    
    func closedDoor(at location: Location2d) -> Bool {
        guard let furnishing = structures[location] else {
            return false
        }
        return furnishing.type == .doorClosed
    }
    
    func opendDoor(at location: Location2d) -> Bool {
        guard let furnishing = structures[location] else {
            return false
        }
        return furnishing.type == .doorOpen
    }
    
    func lockedDoor(at location: Location2d) -> Bool {
        guard let furnishing = structures[location] else {
            return false
        }
        return furnishing.type == .doorLocked

    }
    
    func pathBlocked(at location: Location2d) -> Bool {
        guard let furnishing = structures[location] else {
            return true
        }
        return BuildingStructure.moveBlockers.contains(furnishing.type)
    }
    
    func objects(at location: Location2d) -> [GameObject] {
        let result = objects.filter { (object) -> Bool in
            object.position == location
        }
        return result
    }
}
