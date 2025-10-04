//
//  ShoppingList.swift
//  Evim
//
//  Created by Burak on 2025/10/03.
//

import Foundation

//Name, amount, List of shop objects, List of tag objects, note, deadline date?, photo?, isFinished, createdAt, finishedAt?, url?

struct ShoppingList: Decodable, Identifiable {
    let id: UUID
    let name: String
    let amount: Int
    let createdBy: User
    let shops: [Shop]
    let tags: [Tag]
    let note: String?
    let deadlineDate: Date?
//    let photo: String?
    var isFinished: Bool
    let createdAt: Date
    let finishedAt: Date?
    let onlineShop: [URL]
    
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
}

