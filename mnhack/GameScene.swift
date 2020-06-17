//
//  GameScene.swift
//  mnhack
//
//  Created by Jason Rahaim on 6/16/20.
//  Copyright © 2020 jrdev. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var playerNode: SKNode?
    private var objectNodes = SKNode()
    private var unlitNodes = SKNode()
    private var litNodes = SKNode()
    private var uiNodeds = SKNode()
    private var currentFloorNumber = 0
    let squareSize = 20
    let xOffset = -500
    let yOffset = -350
    
    func scenePoint(location: Location2d) -> CGPoint {
        return scenePoint(location.x, location.y)
    }
    
    func scenePoint(_ x: Int, _ y: Int) -> CGPoint {
        return CGPoint(x: x * squareSize + xOffset, y: y * squareSize + yOffset)
    }
    
    override func didMove(to view: SKView) {
        let world = World.shared
        let player = world.player
        let playerNode = SKLabelNode.init(text: player.appearence)
        playerNode.fontSize = CGFloat(squareSize)
        playerNode.position = scenePoint(location: player.position)
        
        self.playerNode = playerNode
        self.addChild(playerNode)
        self.addChild(objectNodes)
        addStructureNodes()
        self.addChild(unlitNodes)
        self.addChild(litNodes)
        self.addChild(uiNodeds)
        lightVisible()
    }
    
    override func keyDown(with event: NSEvent) {
        let world = World.shared
        let floor = world.floor(currentFloorNumber)
        let player = World.shared.player
        
        var move: Direction?
        
        switch event.keyCode {
        case 125:
            move = .south
        case 126:
            move = .north
        case 123:
            move = .west
        case 124:
            move = .east
        default:
            print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
        }
        if let moveDirection = move {
            // player tried to move
            let newLocation = player.position.pos(moveDirection)
            if world.pathBlocked(floor: currentFloorNumber, location: newLocation) == false {
                player.position = newLocation
                self.playerNode?.position = scenePoint(location: newLocation)
            } else if floor.structures[newLocation]?.type == .doorClosed {
                // replace it with an open door
                floor.structures[newLocation] = BuildingStructure(type: .doorOpen)
                
                let door = self.litNodes.children.first { (node) -> Bool in
                    return (node.position == scenePoint(location: newLocation))
                }
                if let door = door {
                    door.removeFromParent()
                    addStructureNode(BuildingStructure(type: .doorOpen), newLocation)
                }
            }
        }
        unlitNodes.children.forEach() {
            $0.alpha = 0.0
        }
        lightVisible()
    }
    
    func lightVisible() {
        let rays = PossiblyVisiblePoints.rays(distance: 3)
        let floor = World.shared.floor(currentFloorNumber)
        rays.forEach() {ray in
            for i in (0..<ray.count) {
                let offset = ray[i]
                let pos = World.shared.player.position + offset
                let nodes = self.unlitNodes.children.filter { (node) -> Bool in
                    return node.position == scenePoint(pos.x, pos.y)
                }
                nodes.forEach() {
                    $0.alpha = 1.0
                }
                let nodes2 = self.litNodes.children.filter { (node) -> Bool in
                    return node.position == scenePoint(pos.x, pos.y)
                }
                nodes2.forEach() {
                    $0.alpha = 1.0
                }
                if floor.structures[pos]==nil || floor.structures[pos]?.blocksPath() == true {
                    break
                }
            }
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

extension GameScene {
    fileprivate func addStructureNode(_ structure: BuildingStructure, _ pos: Location2d) {
        let node = SKLabelNode(text: structure.appearence)
        node.fontSize = CGFloat(squareSize)
        node.position = scenePoint(location: pos)
        node.alpha = 0.0
        if structure.type == .floor {
            unlitNodes.addChild(node)
        } else {
            litNodes.addChild(node)
        }
    }
    
    func addStructureNodes() {
        let floor = World.shared.floor(currentFloorNumber)
        floor.structures.forEach() {keyValue in
            let (pos, structure) = keyValue
            addStructureNode(structure, pos)
        }
    }
}
