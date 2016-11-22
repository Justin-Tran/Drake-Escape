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
    var music: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func settings(_ sender: Any) {
        
        let settingsPopover: SettingsPopoverViewController = SettingsPopoverViewController()
        settingsPopover.startScreenDel = self
        settingsPopover.presentPopover(sourceController: self, sourceView: self.settingsOutlet, sourceRect: self.settingsOutlet.bounds)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        }
    }

}
