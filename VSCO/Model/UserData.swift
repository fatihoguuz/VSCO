//
//  UserData.swift
//  VSCO
//
//  Created by Fatih Oğuz on 17.07.2024.
//

import Foundation
class UserData {
    static let shared = UserData()
    private init() {
        
    }
    var userName : String?
    var eMail : String?
}
