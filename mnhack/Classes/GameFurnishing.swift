//
//  GameFurnishing.swift
//  mnhack
//
//  Created by Jason Rahaim on 6/17/20.
//  Copyright © 2020 jrdev. All rights reserved.
//

import Foundation

enum GameStructureType {
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
        }
    }
}

class GameStructure {
//    var position: Location2d
//    var floor: Int
    let type: GameStructureType
    let appearence: String
    
    static let moveBlockers: Set<GameStructureType> = [.wall, .doorClosed, .doorLocked]
    
    init(type: GameStructureType, appearence: String) {
        //self.floor = floor
        //self.position = position
        self.type = type
        self.appearence = appearence
    }
    
    func blocksPath() -> Bool {
        return self.type == .doorClosed ||
            self.type == .doorLocked ||
            self.type == .wall
    }
}
