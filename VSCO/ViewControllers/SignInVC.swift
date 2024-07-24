//
//  SignInVC.swift
//  VSCO
//
//  Created by Fatih Oğuz on 17.07.2024.
//

import UIKit
import Firebase

class SignInVC: UIViewController {
    
    
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    
    
    @IBAction func signInButton(_ sender: Any) {
        if  passwordText.text != "" &&  emailText.text != "" {
            
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!){ (result,error) in
                if error != nil {
                    self.makeAlert(message: error?.localizedDescription ?? "error")
                }else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
            }
        }
        }
    }
}
