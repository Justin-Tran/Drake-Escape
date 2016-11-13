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

    var score:String? = nil
    var highScore: Int? = nil
    let highScoreString:String = "NEW HIGH SCORE. GOOD JOB"
    
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
            self.highScore = value?["highScore"] as? Int
            if Int(self.score!)! > self.highScore!
            {
                self.highScoreOutlet.text = self.highScoreString
                ref.child("\(user!.uid)").updateChildValues(["highScore" : self.score!])
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
