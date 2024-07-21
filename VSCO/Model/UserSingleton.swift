//
//  UserSingleton.swift
//  VSCO
//
//  Created by Fatih Oğuz on 19.07.2024.
//

import Foundation

class UserSingleton {
    
    static let sharedUserInfo = UserSingleton()
    
    var email = ""
    var username = ""
    
    private init(){
        
    }
}
