//
//  User.swift
//  Evim
//
//  Created by Burak on 2025/10/03.
//

import Foundation

enum AuthType: String, Decodable {
    case google
    case apple
}

struct User: Decodable {
    let authType: AuthType
    let name: String
    let email: String
}
