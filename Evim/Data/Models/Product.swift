//
//  Product.swift
//  Evim
//
//  Created by Burak on 2025/10/07.
//

import Foundation

struct Product: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var note: String?
    var tags: [Tag]?
    //photo
    let createdAt: Date
    let createdBy: User

    static func == (lhs: Product, rhs: Product) -> Bool {
        lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.note == rhs.note &&
        lhs.tags == rhs.tags
    }
}
