//
//  GameFurnishing.swift
//  mnhack
//
//  Created by Jason Rahaim on 6/17/20.
//  Copyright © 2020 jrdev. All rights reserved.
//

import Foundation

enum BuildingStructureType {
    case doorOpen
    case doorClosed
    case doorLocked
    case wall
    case floor
    case hall
    case stairsUp
    case stairsDown
    case hole
    
    func appearence() -> String {
        switch self {
        case .doorOpen:
            return "-"
        case .doorClosed:
            return "+"
        case .doorLocked:
            return "+"
        case .wall:
            return "#"
        case .floor:
            return "."
        case .hall:
            return "."
        case .stairsUp:
            return "<"
        case .stairsDown:
            return ">"
        case .hole:
            return " "
        }
    }
}

class BuildingStructure {
//    var position: Location2d
//    var floor: Int
    let type: BuildingStructureType
    let appearence: String
    
    static let moveBlockers: Set<BuildingStructureType> = [.wall, .doorClosed, .doorLocked]
    
    init(type: BuildingStructureType) {
        //self.floor = floor
        //self.position = position
        self.type = type
        self.appearence = type.appearence()
    }
    
    func blocksPath() -> Bool {
        return self.type == .doorClosed ||
            self.type == .doorLocked ||
            self.type == .wall
    }
}
