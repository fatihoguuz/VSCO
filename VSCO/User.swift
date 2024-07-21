//
//  User.swift
//  VSCO
//
//  Created by Fatih Oğuz on 2.07.2024.
//

import Foundation
import par


struct User: ParseUser {
    // These are required by `ParseObject`.
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?

    // These are required by `ParseUser`.
    var username: String?
    var email: String?
    var FullName: String?
    var emailVerified: Bool?
    var password: String?
    var authData: [String: [String: String]?]?
}
