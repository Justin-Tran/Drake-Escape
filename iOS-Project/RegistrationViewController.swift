//
//  RegistrationViewController.swift
//  iOS-Project
//
//  Created by Rambo Wu on 11/8/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class RegistrationViewController: UIViewController {
    
    let ref = FIRDatabase.database().reference(withPath: "UserInfo")
    @IBOutlet weak var emailOutlet: UITextField!
    @IBOutlet weak var passwordOutlet: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func registerUser(_ sender: Any) {
        
        // If email is blank or password show a popup.
        
        if emailOutlet.text != "" && passwordOutlet.text != ""
        {
            FIRAuth.auth()!.createUser(withEmail: emailOutlet.text!, password: passwordOutlet.text!, completion: { (user, error) in
                if error == nil
                {
                    print("added user")
                    // perform segue with cancel button identifier???????
                }
                else
                {
                    //its a dictionary UserInfo->error_name = ERROR_EMAIL_ALREADY_IN_USE
                    print("hello")
                    let code = FIRAuthErrorCode(rawValue: (error as! NSError).code)
                    print(code!)
                    switch code! {
                    case .errorCodeInvalidEmail:
                        print("invalid email")
                    case .errorCodeEmailAlreadyInUse:
                        print("in use")
                    case .errorCodeWeakPassword:
                        print("weak ass password lookin b")
                    default:
                        print("Error oh no \(code!)")
                    }
                }
            })
        }
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
