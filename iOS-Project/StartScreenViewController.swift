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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func settings(_ sender: Any) {
        let alert: UIAlertController = UIAlertController(title: "Settings", message: "More settings to come in Final Release", preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (action:UIAlertAction) in
        }
        alert.addAction(cancelAction)
        let OKAction = UIAlertAction(title: "Log Off", style: UIAlertActionStyle.default) { (action:UIAlertAction) in
            try! FIRAuth.auth()!.signOut()
            self.performSegue(withIdentifier: "logout", sender: self)
        }
        alert.addAction(OKAction)
        
        self.present(alert, animated: true, completion:nil)
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
