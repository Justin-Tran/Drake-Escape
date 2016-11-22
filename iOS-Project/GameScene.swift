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
    
    var gameViewControl: GameViewController? = nil
    var backgroundMusic: SKAudioNode!
    var enemyPaparazziArr:[SKSpriteNode] = [SKSpriteNode]()
    var enemyTwitterArr:[SKSpriteNode] = [SKSpriteNode]()
    let player = SKSpriteNode(imageNamed: "StillDrake")
    var runTextureArray = [SKTexture]()
    let album = SKSpriteNode(imageNamed: "fireAlbum")
    var hasAlbum = true
    var activeAlbum = false
    var gamePaused = false
    let pauseButton = SKSpriteNode(imageNamed: "pause")
    let heart_1 = SKSpriteNode(imageNamed: "heart")
    let heart_2 = SKSpriteNode(imageNamed: "heart")
    let heart_3 = SKSpriteNode(imageNamed: "heart")
    var frameCount = 0
    var numLives = 3
    var numJumps = 0
    var firstTouch = 0
    var touchingScreen = false
    var moveDirection = "Left"
    let scoreLabel = SKLabelNode(fontNamed: "The Bold Font")
    let holdToMove = SKLabelNode(fontNamed: "The Bold Font")
    let tapToJump = SKLabelNode(fontNamed: "The Bold Font")
    let avoidEnemies = SKLabelNode(fontNamed: "The Bold Font")
    let tapToFire = SKLabelNode(fontNamed: "The Bold Font")
    let touchtoPickup = SKLabelNode(fontNamed: "The Bold Font")
    let jumpOnEnemies = SKLabelNode(fontNamed: "The Bold Font")
    var gameScore: Int = 0
    var gameArea: CGRect
    
    struct PhysicsCategories {
        static let None : UInt32 = 0x1 << 0
        static let Ground : UInt32 = 0x1 << 1
        static let Player : UInt32 = 0x1 << 2
        static let Enemy : UInt32 = 0x1 << 3
        static let Album : UInt32 = 0x1 << 4
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
        // Setup Texture for Drake
        for i in 1...12 {
            let textureName = "Run\(i)"
            runTextureArray.append(SKTexture(imageNamed: textureName))
        }
        
        // Background Music
        if let musicURL = Bundle.main.url(forResource: "HotlineBlingInstrumental", withExtension: "mp3") {
            backgroundMusic = SKAudioNode(url: musicURL)
            addChild(backgroundMusic)
        }
        // Set Contact Delegate
        self.physicsWorld.contactDelegate = self
        
        // Create Background
        let background = SKSpriteNode(imageNamed: "city_bg")
        background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        background.size.width = frame.size.width
        background.size.height = frame.size.height
        background.zPosition = 0
        addChild(background)
        
        // Create Score Label
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 70
        scoreLabel.fontColor = SKColor.white
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLabel.position = CGPoint(x: self.size.width*0.025, y: self.size.height*0.8)
        scoreLabel.zPosition = 100
        self.addChild(scoreLabel)
        
        // Create Instruction Labels
        holdToMove.text = "Hold the left or right side of the screen to move"
        holdToMove.fontSize = 70
        holdToMove.fontColor = SKColor.white
        holdToMove.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.7)
        holdToMove.zPosition = 100
        holdToMove.isHidden = true
        self.addChild(holdToMove)
        
        tapToJump.text = "Tap screen while moving to jump"
        tapToJump.fontSize = 70
        tapToJump.fontColor = SKColor.white
        tapToJump.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.7)
        tapToJump.zPosition = 100
        tapToJump.isHidden = true
        self.addChild(tapToJump)
        
        avoidEnemies.text = "Avoid touching enemies"
        avoidEnemies.fontSize = 70
        avoidEnemies.fontColor = SKColor.white
        avoidEnemies.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.7)
        avoidEnemies.zPosition = 100
        avoidEnemies.isHidden = true
        self.addChild(avoidEnemies)
        
        tapToFire.text = "Tap ground to shoot mixtape at enemies"
        tapToFire.fontSize = 70
        tapToFire.fontColor = SKColor.white
        tapToFire.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.17)
        tapToFire.zPosition = 100
        tapToFire.isHidden = true
        self.addChild(tapToFire)
        
        touchtoPickup.text = "Pickup mixtape to shoot again"
        touchtoPickup.fontSize = 70
        touchtoPickup.fontColor = SKColor.white
        touchtoPickup.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.17)
        touchtoPickup.zPosition = 100
        touchtoPickup.isHidden = true
        self.addChild(touchtoPickup)
        
        jumpOnEnemies.text = "You can also jump on enemies"
        jumpOnEnemies.fontSize = 70
        jumpOnEnemies.fontColor = SKColor.white
        jumpOnEnemies.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.7)
        jumpOnEnemies.zPosition = 100
        jumpOnEnemies.isHidden = true
        self.addChild(jumpOnEnemies)

        // Create Lives
        heart_1.position = CGPoint(x: self.size.width*0.78, y: self.size.height*0.825)
        heart_2.position = CGPoint(x: self.size.width*0.83, y: self.size.height*0.825)
        heart_3.position = CGPoint(x: self.size.width*0.88, y: self.size.height*0.825)
        heart_1.zPosition = 100
        heart_2.zPosition = 100
        heart_3.zPosition = 100
        heart_1.setScale(0.1)
        heart_2.setScale(0.1)
        heart_3.setScale(0.1)
        self.addChild(heart_1)
        self.addChild(heart_2)
        self.addChild(heart_3)
        
        // Create Pause Button
        pauseButton.position = CGPoint(x: self.size.width*0.95, y: self.size.height*0.825)
        pauseButton.zPosition = 100
        pauseButton.setScale(0.20)
        self.addChild(pauseButton)
        
        // Create Platforms
        makePlatforms()
        
        // Create Player
        makePlayer()
        
        // Spawn Enemies via Time Interval
        let spawnPaparazzi = SKAction.run(makePaparazziEnemy)
        let waitToSpawnPaparazzi = SKAction.wait(forDuration: 10)
        let spawnPaparazziSequence = SKAction.sequence([waitToSpawnPaparazzi, spawnPaparazzi])
        let spawnPaparazziForever = SKAction.repeatForever(spawnPaparazziSequence)
        self.run(spawnPaparazziForever, withKey: "spawningPaparazziEnemies")
        
        let spawnTwitter = SKAction.run(makeTwitterEnemy)
        let waitToSpawnTwitter = SKAction.wait(forDuration: 25)
        let spawnTwitterSequence = SKAction.sequence([waitToSpawnTwitter, spawnTwitter])
        let spawnTwitterForever = SKAction.repeatForever(spawnTwitterSequence)
        self.run(spawnTwitterForever, withKey: "spawningTwitterEnemies")
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
        // player and ground make contact
        if body1.categoryBitMask == PhysicsCategories.Ground && body2.categoryBitMask == PhysicsCategories.Player {
            numJumps = 0
            if(touchingScreen) {
                player.action(forKey: "running")?.speed = 1
            }
        }
        // player and enemy make contact
        if body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.Enemy {
            let enemyHead = (body2.node?.position.y)! + (body2.node?.frame.size.height)!/2
            let playerFeet = (body1.node?.position.y)! - (body1.node?.frame.size.height)!/2 + 10
            
            if(playerFeet < enemyHead) {
                loseLife()
            }
            else {
                addScore()
            }
            body2.collisionBitMask = PhysicsCategories.None
            body2.categoryBitMask = PhysicsCategories.None
        }
        // album and enemy make contact
        if body1.categoryBitMask == PhysicsCategories.Enemy && body2.categoryBitMask == PhysicsCategories.Album {
            if(activeAlbum) {
                activeAlbum = false
                addScore()
                body1.collisionBitMask = PhysicsCategories.None
                body1.categoryBitMask = PhysicsCategories.None
                body2.collisionBitMask = PhysicsCategories.Ground
            }
        }
        // player and album make contact
        if body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.Album {
            hasAlbum = true
            album.physicsBody!.collisionBitMask = PhysicsCategories.Ground | PhysicsCategories.Enemy
        }
    }
    
    func pauseUnpauseGame() {
        if(gamePaused) {
            backgroundMusic.isPaused = false
            scene?.physicsWorld.speed = 1.0
            self.scene?.view?.isPaused = false
            gamePaused = false
        }
        else {
            backgroundMusic.isPaused = true
            scene?.physicsWorld.speed = 1.0
            self.scene?.view?.isPaused = true
            touchingScreen = false
            gamePaused = true
        }
    }
    
    func playerJump() {
        player.action(forKey: "running")?.speed = 0
        player.texture = SKTexture(imageNamed: "Run10")
        numJumps += 1
        if(numJumps <= 2) {
            player.physicsBody?.velocity = CGVector(dx: (player.physicsBody?.velocity.dx)!/3, dy: 0)
            player.physicsBody!.applyImpulse(CGVector(dx: 0.0, dy: 600))
        }
    }
    
    func addScore() {
        gameScore += 100
        scoreLabel.text = "Score: \(gameScore)"
    }
    
    func loseLife() {
        // Knockback to indicate damage
        if(moveDirection == "Left") {
            player.physicsBody?.applyImpulse(CGVector(dx: 150, dy: 300))
        }
        else {
            player.physicsBody?.applyImpulse(CGVector(dx: -150, dy: 300))
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
    
    func throwAlbum(_ direction: String) {
        hasAlbum = false
        activeAlbum = true
        album.isHidden = false
        if(direction == "Right") {
            album.physicsBody?.velocity =  CGVector(dx: 0, dy: 0)
            album.physicsBody?.applyImpulse(CGVector(dx: 175, dy: 100))
        }
        else {
            album.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            album.physicsBody?.applyImpulse(CGVector(dx: -175, dy: 100))
        }
    }
    
    func gameOver() {
        // segues to game over screen and deallocates sprites
        backgroundMusic.removeFromParent()
        gameViewControl?.performSegue(withIdentifier: "gameOverID", sender: gameViewControl!)
        self.removeAllActions()
        self.removeAllChildren()
        gameViewControl?.removeFromParentViewController()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        player.run(SKAction.repeatForever(SKAction.animate(with: runTextureArray, timePerFrame: 0.08)), withKey: "running")
        
        let touchXPosition = (touches.first?.location(in: self).x)!
        let touchYPosition = (touches.first?.location(in: self).y)!
        
        if(pauseButton.contains(touches.first!.location(in: self))) {
            pauseUnpauseGame()
        }
        
        if(!gamePaused) {
            // Throw Album
            if(hasAlbum && touchYPosition < frame.size.height * 0.25 && frameCount > 900) {
                if(touchXPosition > player.position.x) {
                    throwAlbum("Right")
                }
                else {
                    throwAlbum("Left")
                }
            }
            // Jump only if already moving
            if(touchingScreen) {
                playerJump()
            }
            // Set direction of movement and face player character the correct direction
            if(frame.size.width/2 <= touchXPosition && !touchingScreen) {
                if(moveDirection == "Left") {
                    player.xScale = player.xScale * -1
                }
                moveDirection = "Right"
            }
            if(frame.size.width/2 > touchXPosition && !touchingScreen) {
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
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(firstTouch == touches.first?.hash) {
            player.removeAction(forKey: "running")
            player.texture = SKTexture(imageNamed: "StillDrake")
            touchingScreen = false
        }
        super.touchesEnded(touches, with: event)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if(!gamePaused) {
            // Count Frames
            frameCount += 1
            
            // Start a minigame every 45 secounds
            if(frameCount % 2700 == 0)
            {
                pauseUnpauseGame()
                self.gameViewControl!.performSegue(withIdentifier: "popoverTrivia", sender: self.gameViewControl!)
            }
            
            if(frameCount < 300) {
                holdToMove.isHidden = false
            }
            if(frameCount > 300 && frameCount < 600) {
                holdToMove.isHidden = true
                tapToJump.isHidden = false
            }
            if(frameCount > 600 && frameCount < 900) {
                tapToJump.isHidden = true
                avoidEnemies.isHidden = false
            }
            if(frameCount > 900 && frameCount < 1200) {
                avoidEnemies.isHidden = true
                tapToFire.isHidden = false
            }
            if(frameCount > 1200 && frameCount < 1500) {
                tapToFire.isHidden = true
                touchtoPickup.isHidden = false
            }
            if(frameCount > 1500 && frameCount < 1800) {
                touchtoPickup.isHidden = true
                jumpOnEnemies.isHidden = false
            }
            if(frameCount > 1800) {
                jumpOnEnemies.isHidden = true
            }
            
            // Move Player
            if(touchingScreen) {
                if(moveDirection == "Right") {
                    player.position.x += 5
                }
                if(moveDirection == "Left") {
                    player.position.x -= 5
                }
            }
            // Move Album
            if(hasAlbum) {
                album.isHidden = true
                album.position = player.position
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
            
            // Teleport Album
            if(album.position.x > frame.size.width) {
                album.position.x = 0
            }
            if(album.position.x < 0) {
                album.position.x = frame.size.width
            }
            if(album.position.y < 0) {
                album.position.y = frame.size.height
            }

            
            // Move Paparazzi Enemy
            for enemy in enemyPaparazziArr {
                var dx = 0
                if(player.position.x - enemy.position.x > 20) {
                    dx = 120
                    if(enemy.xScale > 0) {
                        enemy.xScale = enemy.xScale * -1
                    }
                }
                else if (player.position.x - enemy.position.x < -20) {
                    dx = -120
                    if(enemy.xScale < 0) {
                        enemy.xScale = enemy.xScale * -1
                    }
                }
                else {
                    dx = 0
                }
                enemy.physicsBody?.velocity.dx = CGFloat(dx)
                if enemy.position.y < -10 {
                    enemy.removeFromParent()
                    enemyPaparazziArr.remove(at: enemyPaparazziArr.index(of: enemy)!)
                }
            }
            
            // Move Twitter Enemy
            if(frameCount % 30 == 0) {
                for enemy in enemyTwitterArr {
                    if(enemy.physicsBody?.categoryBitMask != PhysicsCategories.None) {
                        var dx = 0
                        if(player.position.x - enemy.position.x > 20) {
                            dx = 60
                            if(enemy.xScale < 0) {
                                enemy.xScale = enemy.xScale * -1
                            }
                        }
                        else if (player.position.x - enemy.position.x < -20) {
                            dx = -60
                            if(enemy.xScale > 0) {
                                enemy.xScale = enemy.xScale * -1
                            }
                        }
                        var dy = 0
                        if(player.position.y - enemy.position.y > 20) {
                            dy = 200
                        }
                        else if (player.position.y - enemy.position.y < -20) {
                            dy = 80
                        }
                        
                        enemy.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                        enemy.physicsBody?.applyImpulse(CGVector(dx: dx, dy: dy))
                        if enemy.position.y < -10 {
                            enemy.removeFromParent()
                            enemyTwitterArr.remove(at: enemyTwitterArr.index(of: enemy)!)
                        }
                    }
                }
            }
        }
    }
    
    func makePlatforms() {
        // Make Floor
        let z = SKSpriteNode(imageNamed: "castleMid")
        let floorWidth = z.size.width
        
        for i in 0...15 {
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
            c.physicsBody!.categoryBitMask = PhysicsCategories.Ground
            d.physicsBody!.categoryBitMask = PhysicsCategories.Ground
            e.physicsBody!.categoryBitMask = PhysicsCategories.Ground
            f.physicsBody!.categoryBitMask = PhysicsCategories.Ground
            
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
        // Create Player
        player.position = CGPoint(x: frame.size.width/2, y: 900)
        player.zPosition = 2
        player.setScale(0.5)
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.allowsRotation = false
        player.physicsBody!.categoryBitMask = PhysicsCategories.Player
        player.physicsBody!.collisionBitMask = PhysicsCategories.Ground | PhysicsCategories.Enemy
        player.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy | PhysicsCategories.Ground
        addChild(player)
        
        // Create Album
        album.position = CGPoint(x: frame.size.width/2, y: 900)
        album.zPosition = 2
        album.setScale(0.07)
        album.physicsBody = SKPhysicsBody(rectangleOf: album.size)
        album.physicsBody!.categoryBitMask = PhysicsCategories.Album
        album.physicsBody!.collisionBitMask = PhysicsCategories.Ground | PhysicsCategories.Enemy
        album.physicsBody!.contactTestBitMask = PhysicsCategories.Player | PhysicsCategories.Enemy
        addChild(album)
    }
    
    func makePaparazziEnemy() {
        if(!gamePaused){
            let enemy = SKSpriteNode(imageNamed: "paparazziEnemy")
            var eStartX = CGFloat(0)
            if(player.position.x > frame.size.width/2) {
                eStartX = random(min: 10, max: CGFloat(frame.size.width-10)/2)
            }
            else {
                eStartX = random(min: CGFloat(frame.size.width-10)/2, max: CGFloat(frame.size.width-10))
            }
            let eStartY = CGFloat(1500)
            enemy.position = CGPoint(x: eStartX, y: eStartY)
            enemy.zPosition = 2
            enemy.setScale(0.4)
            enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
            enemy.physicsBody?.allowsRotation = false
            enemy.physicsBody!.categoryBitMask = PhysicsCategories.Enemy
            enemy.physicsBody!.collisionBitMask = PhysicsCategories.Ground | PhysicsCategories.Enemy
            enemy.physicsBody!.contactTestBitMask = PhysicsCategories.Player

            enemyPaparazziArr.append(enemy)
            addChild(enemy)
        }
    }
    
    func makeTwitterEnemy() {
        if(!gamePaused){
            let enemy = SKSpriteNode(imageNamed: "twitterEnemy")
            var eStartX = CGFloat(0)
            if(player.position.x > frame.size.width/2) {
                eStartX = random(min: 10, max: CGFloat(frame.size.width-10)/2)
            }
            else {
                eStartX = random(min: CGFloat(frame.size.width-10)/2, max: CGFloat(frame.size.width-10))
            }
            let eStartY = CGFloat(1500)
            enemy.position = CGPoint(x: eStartX, y: eStartY)
            enemy.zPosition = 2
            enemy.setScale(0.15)
            enemy.physicsBody = SKPhysicsBody(circleOfRadius: enemy.size.height*0.7)
            enemy.physicsBody?.allowsRotation = false
            enemy.physicsBody!.categoryBitMask = PhysicsCategories.Enemy
            enemy.physicsBody!.collisionBitMask = PhysicsCategories.Enemy
            enemy.physicsBody!.contactTestBitMask = PhysicsCategories.Player
        
            enemyTwitterArr.append(enemy)
            addChild(enemy)
        }
    }

}
