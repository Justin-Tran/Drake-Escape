//
//  RegistrationViewController.swift
//  iOS-Project
//
//  Created by Rambo Wu on 11/8/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import Firebase

class RegistrationViewController: UIViewController {
    
    let ref = FIRDatabase.database().reference(withPath: "UserInfo")
    @IBOutlet weak var emailOutlet: UITextField!
    @IBOutlet weak var passwordOutlet: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "regbg")!)
        passwordOutlet.isSecureTextEntry = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func registerUser(_ sender: Any) {
        
        // If email is blank or password show a popup.
        let email: String = emailOutlet.text!
        let pass: String = passwordOutlet.text!
        let alert: UIAlertController = UIAlertController(title: "Login Error", message: "temp", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        if email != "" && pass != ""
        {
            
            FIRAuth.auth()!.createUser(withEmail: email, password: pass, completion: { (user, error) in
                if error == nil
                {
                    // creates user data and uses the user's uid to reference data
                    let ref = FIRDatabase.database().reference(withPath: "users")
                    let id = ref.child(user!.uid)
                    id.setValue(["email": email, "highScore" : 0, "points" : 0])
                    self.performSegue(withIdentifier: "RegToLogin", sender: self)
                    // perform segue with cancel button identifier???????
                }
                else
                {
                    let code = FIRAuthErrorCode(rawValue: (error as! NSError).code)
                    switch code!
                    {
                        case .errorCodeInvalidEmail:
                            alert.message = "Please enter a valid email address."
                        case .errorCodeEmailAlreadyInUse:
                            alert.message = "Email address is already in use. Please try again."
                        case .errorCodeWeakPassword:
                            alert.message = "Password must be at least 6 characters."
                        default:
                            alert.message = "Login Error. Please try again"
                    }
                    self.present(alert, animated: true, completion: nil)
                    
                }
            })
        }
        else
        {
            alert.message = "Please enter an email and a password to register an account."
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
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
