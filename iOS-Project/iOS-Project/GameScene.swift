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
    
    let player = SKSpriteNode(imageNamed: "8BitDrake")
    var firstTouch = 0
    var grounded = true
    var numJumps = 0
    var touchingScreen = false
    var moveDirection = "Left"
    var gameArea: CGRect
    
    struct PhysicsCategories {
        static let None : UInt32 = 0x1 << 1
        static let Player : UInt32 = 0x1 << 2
        static let Ground : UInt32 = 0x1 << 3
        static let Enemy : UInt32 = 0x1 << 4
    }

    override init(size: CGSize) {
        let maxAspectRatio: CGFloat = 16.0/9.0
        let playableWidth = size.height / maxAspectRatio
        let margin = (size.width - playableWidth) / 2
        gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
            
            a.physicsBody = SKPhysicsBody(rectangleOf: a.size)
            b.physicsBody = SKPhysicsBody(rectangleOf: b.size)
            c.physicsBody = SKPhysicsBody(rectangleOf: c.size)
            d.physicsBody = SKPhysicsBody(rectangleOf: d.size)
            e.physicsBody = SKPhysicsBody(rectangleOf: e.size)
            f.physicsBody = SKPhysicsBody(rectangleOf: f.size)
            a.physicsBody?.affectedByGravity = false
            b.physicsBody?.affectedByGravity = false
            c.physicsBody?.affectedByGravity = false
            d.physicsBody?.affectedByGravity = false
            e.physicsBody?.affectedByGravity = false
            f.physicsBody?.affectedByGravity = false
            a.physicsBody?.isDynamic = false
            b.physicsBody?.isDynamic = false
            c.physicsBody?.isDynamic = false
            d.physicsBody?.isDynamic = false
            e.physicsBody?.isDynamic = false
            f.physicsBody?.isDynamic = false
            
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
        c.position = CGPoint(x: frame.size.width/2, y: 750)
        c.zPosition = 1
        c.physicsBody = SKPhysicsBody(rectangleOf: c.size)
        c.physicsBody?.affectedByGravity = false
        c.physicsBody?.isDynamic = false
        addChild(c)
        
        for i in 1...6 {
            let a = SKSpriteNode(imageNamed: "castleMid")
            let b = SKSpriteNode(imageNamed: "castleMid")
            
            a.position = CGPoint(x: frame.size.width/2 + platformWidth*CGFloat(i), y: 750)
            b.position = CGPoint(x: frame.size.width/2 - platformWidth*CGFloat(i), y: 750)
            
            a.zPosition = 1
            b.zPosition = 1
            
            a.physicsBody = SKPhysicsBody(rectangleOf: a.size)
            b.physicsBody = SKPhysicsBody(rectangleOf: b.size)
            a.physicsBody?.affectedByGravity = false
            b.physicsBody?.affectedByGravity = false
            a.physicsBody?.isDynamic = false
            b.physicsBody?.isDynamic = false
            
            addChild(a)
            addChild(b)
        }
        
        let l = SKSpriteNode(imageNamed: "castleCliffLeft")
        let r = SKSpriteNode(imageNamed: "castleCliffRight")
        l.position = CGPoint(x: frame.size.width/2 - platformWidth*CGFloat(7), y: 750)
        r.position = CGPoint(x: frame.size.width/2 + platformWidth*CGFloat(7), y: 750)
        l.zPosition = 1
        r.zPosition = 1
        l.physicsBody = SKPhysicsBody(rectangleOf: l.size)
        r.physicsBody = SKPhysicsBody(rectangleOf: r.size)
        l.physicsBody?.affectedByGravity = false
        r.physicsBody?.affectedByGravity = false
        l.physicsBody?.isDynamic = false
        r.physicsBody?.isDynamic = false
        addChild(l)
        addChild(r)
    }
    
    func makePlayer() {
        // Draw Body
        player.position = CGPoint(x: frame.size.width/2, y: 900)
        player.zPosition = 2
        player.setScale(0.5)
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.allowsRotation = false
        addChild(player)
    }
    
    func playerJump() {
        player.physicsBody?.velocity = CGVector(dx: (player.physicsBody?.velocity.dx)!/3, dy: 0)
        player.physicsBody!.applyImpulse(CGVector(dx: 0.0, dy: 250))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touchingScreen {
            playerJump()
        }
        
        let touchXPosition = (touches.first?.location(in: self).x)!
        // Set direction of movement and face player character the correct direction
        if(player.position.x < touchXPosition && !touchingScreen) {
            if(moveDirection == "Left") {
                player.xScale = player.xScale * -1
            }
            moveDirection = "Right"
        }
        if(player.position.x > touchXPosition && !touchingScreen) {
            if(moveDirection == "Right") {
                player.xScale = player.xScale * -1
            }
            moveDirection = "Left"
        }
        
        if(!touchingScreen) {
            firstTouch = (touches.first?.hashValue)!
            touchingScreen = true
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(firstTouch == touches.first?.hashValue) {
            touchingScreen = false
        }
        super.touchesEnded(touches, with: event)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Move Player
        if (touchingScreen) {
            if(moveDirection == "Right") {
                player.position.x += 5
            }
            if(moveDirection == "Left") {
                player.position.x -= 5
            }
        }
        // Teleport Player
        if(player.position.x > frame.size.width) {
            player.position.x = 0
        }
        if(player.position.x < 0) {
            player.position.x = frame.size.width
        }
        if(player.position.y < 0) {
            player.position.y = frame.size.height
        }
    }
}
