//
//  GameOverViewController.swift
//  iOS-Project
//
//  Created by Rambo Wu on 10/26/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import Firebase

class GameOverViewController: UIViewController {

    @objc var score:String? = nil
    @objc let highScoreString:String = "NEW HIGH SCORE. GOOD JOB"
    
    @IBOutlet weak var scoreOutlet: UILabel!
    @IBOutlet weak var highScoreOutlet: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scoreOutlet.text = self.score!
        let ref = FIRDatabase.database().reference(withPath: "users")
        let user = FIRAuth.auth()?.currentUser
        // gets value from our database a single time. Updates high score if higher than current high score
        ref.child("\(user!.uid)").observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? NSDictionary
            let highScore = value?["highScore"]! as! Int
            if Int(self.score!)! > abs(highScore)
            {
                self.highScoreOutlet.text = self.highScoreString
                
                // converts score to negative for database storage.
                ref.child("\(user!.uid)").updateChildValues(["highScore" : Int(self.score!)! * -1 ])
            }
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
