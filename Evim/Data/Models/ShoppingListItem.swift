//
//  ShoppingList.swift
//  Evim
//
//  Created by Burak on 2025/10/03.
//

import Foundation

struct ShoppingListItem: Decodable, Identifiable, Equatable {
    let id: UUID
    var name: String
    var amount: Int
    let createdBy: User
    let shops: [Shop]
    let tags: [Tag]
    let note: String?
    let deadlineDate: Date?
//    let photo: String?
    var isFinished: Bool
    let createdAt: Date
    let finishedAt: Date?
    
    // Items contained in this shopping list
    var items: [ShoppingItem] = []
    
    // MARK: - Mutating helpers
    mutating func addItem(_ item: ShoppingItem) {
        items.append(item)
    }
    
    mutating func addItem(name: String, quantity: Int = 1, note: String? = nil, tags: [Tag]? = nil) {
        let item = ShoppingItem(name: name, quantity: quantity, note: note, tags: tags)
        items.append(item)
    }

    // MARK: - Equatable
    static func == (lhs: ShoppingListItem, rhs: ShoppingListItem) -> Bool {
        lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.amount == rhs.amount &&
        lhs.isFinished == rhs.isFinished &&
        lhs.note == rhs.note &&
        lhs.deadlineDate == rhs.deadlineDate &&
        lhs.tags == rhs.tags &&
        lhs.shops == rhs.shops
    }
}

