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
    private var objectNodes = [SKNode]()
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
    }
    
    override func keyDown(with event: NSEvent) {
        let world = World.shared
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
            if world.pathBlocked(floor: 0, location: newLocation) == false {
                player.position = newLocation
                self.playerNode?.position = scenePoint(location: newLocation)
            }
        }
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
