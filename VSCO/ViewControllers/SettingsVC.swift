//
//  SettingsVC.swift
//  VSCO
//
//  Created by Fatih Oğuz on 19.07.2024.
//

import UIKit
import Firebase

class SettingsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    

    @IBAction func logoutButton(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toLaunchVC", sender: nil)
        }catch{
            
        }
    }
    

}
