//
//  GameViewController.swift
//  iOS-Project
//
//  Created by Justin Tran on 9/29/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    @objc var scene: GameScene? = nil
    @objc var music: Bool = true
    @objc var drakeSkin: String = "Red"
    @objc var map: String = "city_bg"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scene = GameScene(size: CGSize(width: 2048, height: 1536))
        // Configure the view.
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        self.scene?.scaleMode = .aspectFill
        
        self.scene?.music = self.music
        self.scene?.drakeSkin = self.drakeSkin
        self.scene?.map = self.map
        self.scene?.gameViewControl = self
        skView.presentScene(self.scene)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? GameOverViewController
        {
            // store the score in a property of the destination view controller so it can be set in the label.
            destination.score = "\((scene?.gameScore)!)"
        }
        if let destination = segue.destination as? TriviaViewController
        {
            destination.gameView = self
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
