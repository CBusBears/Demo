//
//  LoginViewController.swift
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

class LoginViewController: UIViewController {
    
    @IBOutlet var Email: UITextField!
    @IBOutlet var Password: UITextField!
    var ref: FIRDatabaseReference?
    
    override func viewDidAppear(_ animated: Bool) {
        
        
         let (username, password, email) = retrieveLocalArchivedData()
         if username != "nil" {
            Email.text = email
            Password.text = password
         }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
    
    }
    @IBAction func toSignUp(_ sender: Any) {
        self.performSegue(withIdentifier: "toSignUp", sender: self)
    }
    
    @IBAction func Login(_ sender: Any) {
        if (Password.text! == "" || Email.text! == "" || (Password.text?.characters.count)! < 6) {
            let alert = UIAlertController(title: "Oops", message:
                "Make sure all the fields are filled. Your password must meet six characters.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            FIRAuth.auth()?.signIn(withEmail: Email.text!, password: Password.text!) {
                (user, error) in
                if error == nil {
                    self.performSegue(withIdentifier: "toPrimaryFromLogin", sender: self)
                } else {
                    let alert = UIAlertController(title: "Oops", message:
                        "We could not find an account with these credentials.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func retrieveLocalArchivedData() -> (String?,String?,String?) {
        let userExist = isKeyPresentInUserDefaults(key: "Username")
        var username: String?
        var password: String?
        var email: String?
        if userExist {
            username = UserDefaults.standard.string(forKey: "Username")
            password = UserDefaults.standard.string(forKey: "Password")
            email = UserDefaults.standard.string(forKey: "Email")
        } else {
            username = "nil"
            password = "nil"
            email = "nil"
        }
        return (username, password, email)
    }
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
   
    
}
