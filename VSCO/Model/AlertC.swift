//
//  AlertC.swift
//  VSCO
//
//  Created by Fatih Oğuz on 22.07.2024.
//

import Foundation
import UIKit


extension UIViewController {
    
    func makeAlert(title: String = "Error" , message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default , handler:  nil)
    alert.addAction(okButton)
    self.present(alert,animated: true , completion: nil)
}
    
}
