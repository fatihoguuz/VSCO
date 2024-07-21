//
//  ViewController.swift
//  VSCO
//
//  Created by Fatih Oğuz on 30.06.2024.
//

import UIKit

class LaunchVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func signUpButton(_ sender: Any) {
        performSegue(withIdentifier: "toSignUpVC", sender: nil)
    }
    
    @IBAction func signInButton(_ sender: Any) {
        performSegue(withIdentifier: "toSignInVC", sender: nil)
    }
    
}

