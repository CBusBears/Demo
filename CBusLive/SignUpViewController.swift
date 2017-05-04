//
//  SignUpViewController.swift
//  CNub
//
//  Created by Benjamin Hobson on 3/25/17.
//  Copyright © 2017 Benjamin Hobson. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseDatabase

class SignUpViewController: UIViewController {
    
    @IBOutlet var Username: UITextField!
    @IBOutlet var Password: UITextField!
    @IBOutlet var Email: UITextField!
    
    var ref: FIRDatabaseReference?
    
    //add aboves if program?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func returnToLogin(_ sender: Any) {
        self.performSegue(withIdentifier: "toLoginFromSignUp", sender: self)
    }
    
    @IBAction func SignUp(_ sender: Any) {
        
        if (Username.text == "" || Password.text == "" || Email.text == "") {
            let alert = UIAlertController(title: "Oops", message:
                "Make sure all the fields are filled", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            FIRAuth.auth()?.createUser(withEmail: Email.text!, password: Password.text!) {
                (user, error) in
                if error == nil {
                    UserDefaults.standard.set(self.Email.text!, forKey: "Email")
                    UserDefaults.standard.set(self.Password.text!, forKey: "Password")
                    UserDefaults.standard.set(self.Username.text!, forKey: "Username")
                    FIRAuth.auth()!.signIn(withEmail: self.Email.text!, password: self.Password.text!) {
                        (user, error) in
                        if error == nil {
                            self.performSegue(withIdentifier: "toPrimaryFromSignUp", sender: self)
                        } else {
                            let alert = UIAlertController(title: "Oops", message:
                                "Account creation was succesful, Login failed", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                } else {
                    let alert = UIAlertController(title: "Oops", message:
                        "We could not sign you in", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}

