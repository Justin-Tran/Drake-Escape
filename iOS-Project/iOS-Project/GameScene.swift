//
//  GameScene.swift
//  iOS-Project
//
//  Created by Justin Tran on 9/29/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
        // Create Background
        let background = SKSpriteNode(imageNamed: "bg_forest")
        background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        background.size.width = frame.size.width
        background.size.height = frame.size.height
        background.zPosition = 0
        addChild(background)
        
        // Create Platforms
        makePlatforms()
        
        // Create Player
        makePlayer()
    }
    
    func makePlatforms() {
        // Make Floor
        let z = SKSpriteNode(imageNamed: "castleMid")
        let floorWidth = z.size.width
        
        for i in 2...15 {
            let a = SKSpriteNode(imageNamed: "castleMid")
            let b = SKSpriteNode(imageNamed: "castleMid")
            let c = SKSpriteNode(imageNamed: "castleCenter")
            let d = SKSpriteNode(imageNamed: "castleCenter")
            let e = SKSpriteNode(imageNamed: "castleCenter")
            let f = SKSpriteNode(imageNamed: "castleCenter")
            
            a.position = CGPoint(x: frame.size.width/2 + floorWidth*CGFloat(i), y: 350)
            b.position = CGPoint(x: frame.size.width/2 - floorWidth*CGFloat(i), y: 350)
            c.position = CGPoint(x: frame.size.width/2 + floorWidth*CGFloat(i), y: 350 - floorWidth)
            d.position = CGPoint(x: frame.size.width/2 - floorWidth*CGFloat(i), y: 350 - floorWidth)
            e.position = CGPoint(x: frame.size.width/2 + floorWidth*CGFloat(i), y: 350 - floorWidth*2)
            f.position = CGPoint(x: frame.size.width/2 - floorWidth*CGFloat(i), y: 350 - floorWidth*2)
            
            a.zPosition = 1
            b.zPosition = 1
            c.zPosition = 1
            d.zPosition = 1
            e.zPosition = 1
            f.zPosition = 1
            
            addChild(a)
            addChild(b)
            addChild(c)
            addChild(d)
            addChild(e)
            addChild(f)
        }
        
        // Make Center Platform
        let c = SKSpriteNode(imageNamed: "castleMid")
        let platformWidth = c.size.width
        c.position = CGPoint(x: frame.size.width/2, y: 700)
        c.zPosition = 1
        addChild(c)
        
        for i in 1...6 {
            let a = SKSpriteNode(imageNamed: "castleMid")
            let b = SKSpriteNode(imageNamed: "castleMid")
            
            a.position = CGPoint(x: frame.size.width/2 + platformWidth*CGFloat(i), y: 700)
            b.position = CGPoint(x: frame.size.width/2 - platformWidth*CGFloat(i), y: 700)
            a.zPosition = 1
            b.zPosition = 1
            
            addChild(a)
            addChild(b)
        }
        
        let l = SKSpriteNode(imageNamed: "castleCliffLeft")
        let r = SKSpriteNode(imageNamed: "castleCliffRight")
        l.position = CGPoint(x: frame.size.width/2 - platformWidth*7, y: 700)
        r.position = CGPoint(x: frame.size.width/2 + platformWidth*7, y: 700)
        l.zPosition = 1
        r.zPosition = 1
        addChild(l)
        addChild(r)
    }
    
    func makePlayer() {
        let player = SKSpriteNode(imageNamed: "8BitDrake")
        player.position = CGPoint(x: frame.size.width/2, y: 900)
        player.zPosition = 2
        player.setScale(0.5)
        addChild(player)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Nothing Yet
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Nothing Yet
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
