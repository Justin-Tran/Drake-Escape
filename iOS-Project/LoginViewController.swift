//
//  LoginViewController.swift
//  iOS-Project
//
//  Created by Rambo Wu on 11/10/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailOutlet: UITextField!
    @IBOutlet weak var passwordOutlet: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordOutlet.isSecureTextEntry = true
        // Do any additional setup after loading the view.
    }

    @IBAction func loginUser(_ sender: Any) {
        
        // If email is blank or password show a popup.
        
        if emailOutlet.text != "" && passwordOutlet.text != ""
        {
            FIRAuth.auth()!.signIn(withEmail: emailOutlet.text!, password: passwordOutlet.text!, completion: { (user, error) in
                if error == nil
                {
                    self.performSegue(withIdentifier: "LoginToStart", sender: self)
                    // perform segue with cancel button identifier???????
                }
                else
                {
                    // declares an alert controller if Firebase fails to authenticate user
                    let alert: UIAlertController = UIAlertController(title: "Login Error", message: "temp", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    
                    let code = FIRAuthErrorCode(rawValue: (error as! NSError).code)
                    print(code!)
                    switch code! {
                    case .errorCodeInvalidEmail:
                        alert.message = "Please enter a valid email address."
                    case .errorCodeUserNotFound:
                        alert.message = "This email address is not in use. Please register an account."
                    case .errorCodeWrongPassword:
                        print("weak ass password lookin b")
                        alert.message = "The email address or password is incorrect. Please try again."
                    default:
                        // should never reach this.
                        assert(false)
                    }
                    self.present(alert, animated: true, completion: nil)
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
