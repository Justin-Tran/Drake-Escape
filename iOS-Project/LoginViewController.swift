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
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask
    {
        return UIInterfaceOrientationMask.portrait
    }
    
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
                    print("hello")
                    let code = FIRAuthErrorCode(rawValue: (error as! NSError).code)
                    print(code!)
                    switch code! {
                    case .errorCodeInvalidEmail:
                        print("invalid email")
                    case .errorCodeUserNotFound:
                        print("nah dawg time to register")
                    case .errorCodeWrongPassword:
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