//
//  Alert.swift
//  VSCO
//
//  Created by Fatih Oğuz on 20.07.2024.
//

import Foundation
import UIKit
import Firebase

class Alert {
    
    static let makeAlert = Alert()
    
    func makeAlert(title: String , message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default , handler:  nil)
        alert.addAction(okButton)
        present(alert,animated: true , completion: self)
    }
    private init() {
        
    }
}
