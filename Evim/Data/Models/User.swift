//
//  User.swift
//  Evim
//
//  Created by Burak on 2025/10/03.
//

import Foundation

enum AuthType: String, Codable {
    case google
    case apple
}

struct User: Codable, Equatable {
    let authType: AuthType
    let name: String
    let email: String

    static func == (lhs: User, rhs: User) -> Bool {
        lhs.authType == rhs.authType &&
        lhs.name == rhs.name &&
        lhs.email == rhs.email
    }
}
