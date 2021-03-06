//
//  StartScreenViewController.swift
//  iOS-Project
//
//  Created by Rambo Wu on 10/26/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import Firebase

class StartScreenViewController: UIViewController {
    
    @IBOutlet weak var settingsOutlet: UIButton!
    @IBOutlet weak var drakeButton: UIButton!
    @IBOutlet weak var mapButton: UIButton!
    
    @objc var music: Bool = true
    @objc var currentSkin: Int = 0
    @objc var currentMap: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func settings(_ sender: Any) {
        
        let settingsPopover: SettingsPopoverViewController = SettingsPopoverViewController()
        settingsPopover.startScreenDel = self
        settingsPopover.presentPopover(sourceController: self, sourceView: self.settingsOutlet, sourceRect: self.settingsOutlet.bounds)
    }

    @IBAction func changeSkin(_ sender: Any) {
        
        if self.currentSkin == 0
        {
            let skin: UIImage = UIImage(named: "BStillDrake")!
            self.drakeButton.setImage(skin, for: .normal)
            self.currentSkin = 1
        }
        else if self.currentSkin == 1
        {
            let skin: UIImage = UIImage(named: "StillDrake")!
            self.drakeButton.setImage(skin, for: .normal)
            self.currentSkin = 0
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeMap(_ sender: Any) {
        
        if self.currentMap == 0
        {
            let skin: UIImage = UIImage(named: "bg_forest")!
            self.mapButton.setImage(skin, for: .normal)
            self.currentMap = 1
        }
        else if self.currentMap == 1
        {
            let skin: UIImage = UIImage(named: "city_bg")!
            self.mapButton.setImage(skin, for: .normal)
            self.currentMap = 0
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let destination = segue.destination as? GameViewController
        {
            // store the score in a property of the destination view controller so it can be set in the label.
            destination.music = self.music
            if self.currentSkin == 0
            {
                destination.drakeSkin = "Red"
            }
            else if self.currentSkin == 1
            {
                destination.drakeSkin = "Black"
            }
            if self.currentMap == 0
            {
                destination.map = "city_bg"
            }
            else if self.currentMap == 1
            {
                destination.map = "bg_forest"
            }
        }
    }

}
