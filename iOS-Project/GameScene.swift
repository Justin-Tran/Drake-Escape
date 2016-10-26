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
    
    var gameViewControl: UIViewController? = nil
    var enemyArr:[SKSpriteNode] = [SKSpriteNode]()
    let player = SKSpriteNode(imageNamed: "8BitDrake")
    let heart_1 = SKSpriteNode(imageNamed: "heart")
    let heart_2 = SKSpriteNode(imageNamed: "heart")
    let heart_3 = SKSpriteNode(imageNamed: "heart")
    var numLives = 3
    var numJumps = 0
    var firstTouch = 0
    var frameCount = 0
    var touchingScreen = false
    var moveDirection = "Left"
    let scoreLabel = SKLabelNode(fontNamed: "The Bold Font")
    var gameScore = 0
    var gameArea: CGRect
    
    struct PhysicsCategories {
        static let None : UInt32 = 0x1 << 0
        static let Ground : UInt32 = 0x1 << 1
        static let Player : UInt32 = 0x1 << 2
        static let Enemy : UInt32 = 0x1 << 3
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    func random(min:CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
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
        // Set Contact Delegate
        self.physicsWorld.contactDelegate = self
        // Create Background
        let background = SKSpriteNode(imageNamed: "city_bg")
        background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        background.size.width = frame.size.width
        background.size.height = frame.size.height
        background.zPosition = 0
        addChild(background)
        
        // Create Score
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 70
        scoreLabel.fontColor = SKColor.white
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLabel.position = CGPoint(x: self.size.width*0.025, y: self.size.height*0.8)
        scoreLabel.zPosition = 100
        self.addChild(scoreLabel)
        
        // Create Lives
        heart_1.position = CGPoint(x: self.size.width*0.85, y: self.size.height*0.825)
        heart_2.position = CGPoint(x: self.size.width*0.90, y: self.size.height*0.825)
        heart_3.position = CGPoint(x: self.size.width*0.95, y: self.size.height*0.825)
        heart_1.zPosition = 100
        heart_2.zPosition = 100
        heart_3.zPosition = 100
        heart_1.setScale(0.1)
        heart_2.setScale(0.1)
        heart_3.setScale(0.1)
        self.addChild(heart_1)
        self.addChild(heart_2)
        self.addChild(heart_3)
        
        // Create Platforms
        makePlatforms()
        
        // Create Player
        makePlayer()
        
        // Spawn Enemies via Time Interval
        let spawn = SKAction.run(makeEnemy)
        let waitToSpawn = SKAction.wait(forDuration: 5)
        let spawnSequence = SKAction.sequence([waitToSpawn, spawn])
        let spawnForever = SKAction.repeatForever(spawnSequence)
        self.run(spawnForever, withKey: "spawningEnemies")
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            body1 = contact.bodyA
            body2 = contact.bodyB
        }
        else {
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        
        if body1.categoryBitMask == PhysicsCategories.Ground && body2.categoryBitMask == PhysicsCategories.Player {
            // player and ground make contact
            numJumps = 0
        }
        
        if body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.Enemy {
            // player and enemy make contact
            loseLife()
        }

    }
    
    func playerJump() {
        numJumps += 1
        if(numJumps <= 2) {
            player.physicsBody?.velocity = CGVector(dx: (player.physicsBody?.velocity.dx)!/3, dy: 0)
            player.physicsBody!.applyImpulse(CGVector(dx: 0.0, dy: 250))
        }
    }
    
    func addScore() {
        gameScore += 100
        scoreLabel.text = "Score: \(gameScore)"
    }
    
    func loseLife() {
        // Knockback to indicate damage
        if(moveDirection == "Left") {
            player.physicsBody?.applyImpulse(CGVector(dx: 80, dy: 200))
        }
        else {
            player.physicsBody?.applyImpulse(CGVector(dx: -80, dy: 200))
        }
        // Decrement life count and remove a heart
        numLives -= 1
        if(numLives == 2) {
            heart_1.isHidden = true
        }
        if(numLives == 1) {
            heart_2.isHidden = true
        }
        if(numLives == 0) {
            heart_3.isHidden = true
            gameOver()
        }
    }
    
    func gameOver() {
        // include segueway to Game Over Screen
        
        print("GAME OVER")
        print("SCORE: " + String(gameScore))
        gameViewControl?.performSegue(withIdentifier: "gameOverID", sender: gameViewControl!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Make Enemy when screen tapped (Temporary)
        //makeEnemy()
        
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
            firstTouch = (touches.first?.hash)!
            touchingScreen = true
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(firstTouch == touches.first?.hash) {
            touchingScreen = false
        }
        super.touchesEnded(touches, with: event)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        frameCount += 1
        if(frameCount > 180) {
            frameCount = 0
        }
        
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
        
        // Move Enemy
        for enemy in enemyArr {
            var dy = 0
            if(frameCount == 180) {
                dy = 200
            }
            enemy.physicsBody?.applyImpulse(CGVector(dx: 0, dy: CGFloat(dy)))
            var dx = 0
            if(player.position.x - enemy.position.x > 0) {
                dx = 120
                if(enemy.xScale > 0) {
                    enemy.xScale = enemy.xScale * -1
                }
            }
            else {
                dx = -120
                if(enemy.xScale < 0) {
                    enemy.xScale = enemy.xScale * -1
                }
            }
            enemy.physicsBody?.velocity.dx = CGFloat(dx)
            if enemy.position.y < -10 {
                addScore()
                enemy.removeFromParent()
                enemyArr.remove(at: enemyArr.index(of: enemy)!)
            }
        }
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
            a.physicsBody!.categoryBitMask = PhysicsCategories.Ground
            a.physicsBody!.collisionBitMask = PhysicsCategories.Player | PhysicsCategories.Enemy
            a.physicsBody!.contactTestBitMask = PhysicsCategories.None
            b.physicsBody!.categoryBitMask = PhysicsCategories.Ground
            b.physicsBody!.collisionBitMask = PhysicsCategories.Player | PhysicsCategories.Enemy
            b.physicsBody!.contactTestBitMask = PhysicsCategories.None

            
            addChild(a)
            addChild(b)
            addChild(c)
            addChild(d)
            addChild(e)
            addChild(f)
        }
        
        // Make Upper Left Platform
        let ul = SKSpriteNode(imageNamed: "castleMid")
        let platformWidth = ul.size.width
        ul.position = CGPoint(x: frame.size.width/2-300, y: 750)
        ul.zPosition = 1
        ul.physicsBody = SKPhysicsBody(rectangleOf: ul.size)
        ul.physicsBody?.affectedByGravity = false
        ul.physicsBody?.isDynamic = false
        ul.physicsBody!.categoryBitMask = PhysicsCategories.Ground
        ul.physicsBody!.collisionBitMask = PhysicsCategories.Player | PhysicsCategories.Enemy
        ul.physicsBody!.contactTestBitMask = PhysicsCategories.None

        addChild(ul)
        
        for i in 1...5 {
            let a = SKSpriteNode(imageNamed: "castleMid")
            let b = SKSpriteNode(imageNamed: "castleMid")
            
            a.position = CGPoint(x: frame.size.width/2 - 300 + platformWidth*CGFloat(i), y: 750)
            b.position = CGPoint(x: frame.size.width/2 - 300 - platformWidth*CGFloat(i), y: 750)
            
            a.zPosition = 1
            b.zPosition = 1
            
            a.physicsBody = SKPhysicsBody(rectangleOf: a.size)
            b.physicsBody = SKPhysicsBody(rectangleOf: b.size)
            a.physicsBody?.affectedByGravity = false
            b.physicsBody?.affectedByGravity = false
            a.physicsBody?.isDynamic = false
            b.physicsBody?.isDynamic = false
            a.physicsBody!.categoryBitMask = PhysicsCategories.Ground
            a.physicsBody!.collisionBitMask = PhysicsCategories.Player | PhysicsCategories.Enemy
            a.physicsBody!.contactTestBitMask = PhysicsCategories.None
            b.physicsBody!.categoryBitMask = PhysicsCategories.Ground
            b.physicsBody!.collisionBitMask = PhysicsCategories.Player | PhysicsCategories.Enemy
            b.physicsBody!.contactTestBitMask = PhysicsCategories.None

            
            addChild(a)
            addChild(b)
        }
        
        let l = SKSpriteNode(imageNamed: "castleCliffLeft")
        let r = SKSpriteNode(imageNamed: "castleCliffRight")
        l.position = CGPoint(x: frame.size.width/2 - 300 - platformWidth*CGFloat(6), y: 750)
        r.position = CGPoint(x: frame.size.width/2 - 300 + platformWidth*CGFloat(6), y: 750)
        l.zPosition = 1
        r.zPosition = 1
        l.physicsBody = SKPhysicsBody(rectangleOf: l.size)
        r.physicsBody = SKPhysicsBody(rectangleOf: r.size)
        l.physicsBody?.affectedByGravity = false
        r.physicsBody?.affectedByGravity = false
        l.physicsBody?.isDynamic = false
        r.physicsBody?.isDynamic = false
        l.physicsBody!.categoryBitMask = PhysicsCategories.Ground
        l.physicsBody!.collisionBitMask = PhysicsCategories.Player | PhysicsCategories.Enemy
        l.physicsBody!.contactTestBitMask = PhysicsCategories.None
        r.physicsBody!.categoryBitMask = PhysicsCategories.Ground
        r.physicsBody!.collisionBitMask = PhysicsCategories.Player | PhysicsCategories.Enemy
        r.physicsBody!.contactTestBitMask = PhysicsCategories.None


        addChild(l)
        addChild(r)
        
        // Make Upper Right Platform
        let ur = SKSpriteNode(imageNamed: "castleMid")
        ur.position = CGPoint(x: frame.size.width/2 + 600, y: 600)
        ur.zPosition = 1
        ur.physicsBody = SKPhysicsBody(rectangleOf: ur.size)
        ur.physicsBody?.affectedByGravity = false
        ur.physicsBody?.isDynamic = false
        ur.physicsBody!.categoryBitMask = PhysicsCategories.Ground
        ur.physicsBody!.collisionBitMask = PhysicsCategories.Player | PhysicsCategories.Enemy
        ur.physicsBody!.contactTestBitMask = PhysicsCategories.None

        addChild(ur)
        
        for i in 1...1 {
            let a = SKSpriteNode(imageNamed: "castleMid")
            let b = SKSpriteNode(imageNamed: "castleMid")
            
            a.position = CGPoint(x: frame.size.width/2 + 600 + platformWidth*CGFloat(i), y: 600)
            b.position = CGPoint(x: frame.size.width/2 + 600 - platformWidth*CGFloat(i), y: 600)
            
            a.zPosition = 1
            b.zPosition = 1
            
            a.physicsBody = SKPhysicsBody(rectangleOf: a.size)
            b.physicsBody = SKPhysicsBody(rectangleOf: b.size)
            a.physicsBody?.affectedByGravity = false
            b.physicsBody?.affectedByGravity = false
            a.physicsBody?.isDynamic = false
            b.physicsBody?.isDynamic = false
            a.physicsBody!.categoryBitMask = PhysicsCategories.Ground
            a.physicsBody!.collisionBitMask = PhysicsCategories.Player | PhysicsCategories.Enemy
            a.physicsBody!.contactTestBitMask = PhysicsCategories.None
            b.physicsBody!.categoryBitMask = PhysicsCategories.Ground
            b.physicsBody!.collisionBitMask = PhysicsCategories.Player | PhysicsCategories.Enemy
            b.physicsBody!.contactTestBitMask = PhysicsCategories.None
            
            addChild(a)
            addChild(b)
        }
        
        let _l = SKSpriteNode(imageNamed: "castleCliffLeft")
        let _r = SKSpriteNode(imageNamed: "castleCliffRight")
        _l.position = CGPoint(x: frame.size.width/2 + 600 - platformWidth*CGFloat(2), y: 600)
        _r.position = CGPoint(x: frame.size.width/2 + 600 + platformWidth*CGFloat(2), y: 600)
        _l.zPosition = 1
        _r.zPosition = 1
        _l.physicsBody = SKPhysicsBody(rectangleOf: _l.size)
        _r.physicsBody = SKPhysicsBody(rectangleOf: _r.size)
        _l.physicsBody?.affectedByGravity = false
        _r.physicsBody?.affectedByGravity = false
        _l.physicsBody?.isDynamic = false
        _r.physicsBody?.isDynamic = false
        _l.physicsBody!.categoryBitMask = PhysicsCategories.Ground
        _l.physicsBody!.collisionBitMask = PhysicsCategories.Player | PhysicsCategories.Enemy
        _l.physicsBody!.contactTestBitMask = PhysicsCategories.None
        _r.physicsBody!.categoryBitMask = PhysicsCategories.Ground
        _r.physicsBody!.collisionBitMask = PhysicsCategories.Player | PhysicsCategories.Enemy
        _r.physicsBody!.contactTestBitMask = PhysicsCategories.None

        addChild(_l)
        addChild(_r)
    }
    
    func makePlayer() {
        player.position = CGPoint(x: frame.size.width/2, y: 900)
        player.zPosition = 2
        player.setScale(0.5)
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.allowsRotation = false
        player.physicsBody!.categoryBitMask = PhysicsCategories.Player
        player.physicsBody!.collisionBitMask = PhysicsCategories.Ground | PhysicsCategories.Enemy
        player.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy | PhysicsCategories.Ground
        addChild(player)
    }
    
    func makeEnemy() {
        let enemy = SKSpriteNode(imageNamed: "Enemy1")
        let eStartX = random(min: 10, max: CGFloat(frame.size.width-10))
        let eStartY = CGFloat(1500)
        enemy.position = CGPoint(x: eStartX, y: eStartY)
        enemy.zPosition = 2
        enemy.setScale(0.40)
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody?.allowsRotation = false
        enemy.physicsBody!.categoryBitMask = PhysicsCategories.Enemy
        enemy.physicsBody!.collisionBitMask = PhysicsCategories.Ground
        enemy.physicsBody!.contactTestBitMask = PhysicsCategories.Player

        enemyArr.append(enemy)
        addChild(enemy)
    }

}
