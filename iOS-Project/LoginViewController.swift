//
//  LoginViewController.swift
//  iOS-Project
//
//  Created by Rambo Wu on 11/10/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {

    @objc var email: String? = nil
    @objc var pass: String? = nil
    @objc var didRegister: Bool = false
    @IBOutlet weak var emailOutlet: UITextField!
    @IBOutlet weak var passwordOutlet: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordOutlet.isSecureTextEntry = true
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "loginbg")!)
        emailOutlet.delegate = self
        passwordOutlet.delegate = self
        if didRegister
        {
            emailOutlet.text = email!
            passwordOutlet.text = pass!
        }
        // Do any additional setup after loading the view.
    }

    @IBAction func loginUser(_ sender: Any) {
        
        let email: String = emailOutlet.text!
        let pass: String = passwordOutlet.text!
        let alert: UIAlertController = UIAlertController(title: "Login Error", message: "temp", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        if email != "" && pass != ""
        {
            FIRAuth.auth()!.signIn(withEmail: email, password: pass, completion: { (user, error) in
                if error == nil
                {
                    self.performSegue(withIdentifier: "LoginToStart", sender: self)
                    // perform segue with cancel button identifier???????
                }
                else
                {
                    // declares an alert controller if Firebase fails to authenticate user
                    
                    
                    let code = FIRAuthErrorCode(rawValue: (error! as NSError).code)
                    switch code! {
                    case .errorCodeInvalidEmail:
                        alert.message = "Please enter a valid email address."
                    case .errorCodeUserNotFound:
                        alert.message = "This email address is not in use. Please register an account."
                    case .errorCodeWrongPassword:
                        alert.message = "The email address or password is incorrect. Please try again."
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailOutlet.resignFirstResponder()
        passwordOutlet.resignFirstResponder()
        loginUser(self)
        return true
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
