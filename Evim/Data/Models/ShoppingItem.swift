// ShoppingItem.swift
import Foundation

struct ShoppingItem: Identifiable, Decodable {
    let id: UUID
    var name: String
    var quantity: Int
    var isCompleted: Bool
    var note: String?
    var tags: [Tag]?
    
    init(id: UUID = UUID(), name: String, quantity: Int = 1, isCompleted: Bool = false, note: String? = nil, tags: [Tag]? = nil) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.isCompleted = isCompleted
        self.note = note
        self.tags = tags
    }
}
