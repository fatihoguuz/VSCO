//
//  SettingsVC.swift
//  VSCO
//
//  Created by Fatih Oğuz on 19.07.2024.
//

import UIKit
import Firebase
import SafariServices

class SettingsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    
    @IBAction func didChangeSegment (_ sender: UISegmentedControl){
        if sender.selectedSegmentIndex == 0{
            let scenes = UIApplication.shared.connectedScenes
                    let windowScene = scenes.first as? UIWindowScene
                    let window = windowScene?.windows.first
                    let interfaceStyle = window?.overrideUserInterfaceStyle == .unspecified ? UIScreen.main.traitCollection.userInterfaceStyle : window?.overrideUserInterfaceStyle
                    
            window?.overrideUserInterfaceStyle = .light
                        
                   
                    
        }else if sender.selectedSegmentIndex == 1{
            let scenes = UIApplication.shared.connectedScenes
                    let windowScene = scenes.first as? UIWindowScene
                    let window = windowScene?.windows.first
                    let interfaceStyle = window?.overrideUserInterfaceStyle == .unspecified ? UIScreen.main.traitCollection.userInterfaceStyle : window?.overrideUserInterfaceStyle
                    
            window?.overrideUserInterfaceStyle = .dark
            
        }
    }
    

    @IBAction func logoutButton(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toLaunchVC", sender: nil)
        }catch{
            
        }
    }
    
    @IBAction func aboutButton(_ sender: Any) {
        performSegue(withIdentifier: "toAboutVC", sender: nil)
    }
    
    
    @IBAction func safetyButton(_ sender: Any) {
        if let url = URL(string: "https://www.vsco.co/safety")
         {

           let safariVC = SFSafariViewController(url: url)
           present(safariVC, animated: true, completion: nil)

         }
    }
    
}
