//
//  SignUpVC.swift
//  VSCO
//
//  Created by Fatih Oğuz on 1.07.2024.
//

import UIKit
import Firebase

import FirebaseAuth

class SignUpVC: UIViewController {
    
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var usernameText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func signUpButton(_ sender: Any) {
        if usernameText.text != "" && passwordText.text != "" &&  emailText.text != "" {
            UserData.shared.eMail = emailText.text
            UserData.shared.userName = usernameText.text
            
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!){ (auth,error) in
                if error != nil {
                    self.makeAlert(title: "ERROR ", message: error?.localizedDescription ?? "error")
                }else{
                    let fireStore = Firestore.firestore()
                    let userDictionary = ["Email":self.emailText.text!,"Username": self.usernameText.text!] as [String: Any]
                    fireStore.collection("UserInfo").addDocument(data: userDictionary){ (error) in
                        if error != nil {
                            
                        }
                    }
                    self.performSegue(withIdentifier: "toHomeVC", sender: nil)
                }
            }
            
        }else {
            self.makeAlert(title: "ERROR", message: "Username/Email/Password ?")
            
        }
    }
    func makeAlert(title: String , message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default , handler:  nil)
        alert.addAction(okButton)
        self.present(alert,animated: true , completion: nil)
    }
}
