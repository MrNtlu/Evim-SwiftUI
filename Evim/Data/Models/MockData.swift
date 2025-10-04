//
//  MockData.swift
//  Evim
//
//  Created by Burak on 2025/10/03.
//

import Foundation

#if DEBUG
enum MockData {
    
    // MARK: - Users
    static let users: [User] = [
        User(authType: .google, name: "Alice Smith", email: "alice@example.com"),
        User(authType: .apple,  name: "Bob Johnson",  email: "bob@example.com")
    ]
    
    static let user: User = users[0]
    
    // MARK: - Tags
    static let tags: [Tag] = [
        Tag(color: "#FF6B6B", emoji: "🍎", label: "Groceries"),
        Tag(color: "#4ECDC4", emoji: "🧼", label: "Cleaning"),
        Tag(color: "#FFD93D", emoji: "🐶", label: "Pet")
    ]
    
    static let tag: Tag = tags[0]
    
    // MARK: - Shops
    static let shops: [Shop] = [
        Shop(id: UUID(), name: "Local Market", createdAt: days(fromNow: -30)),
        Shop(id: UUID(), name: "SuperMart",    createdAt: days(fromNow: -20)),
        Shop(id: UUID(), name: "Pet Store",    createdAt: days(fromNow: -10))
    ]
    
    static let shop: Shop = shops[0]
    
    // MARK: - Shopping Lists
    static let shoppingLists: [ShoppingList] = [
        ShoppingList(
            id: UUID(),
            name: "Weekly Groceries",
            amount: 25,
            createdBy: users[0],
            shops: [shops[0], shops[1]],
            tags: [tags[0]],
            note: "Check discounts on fruits and dairy.",
            deadlineDate: days(fromNow: 2),
            isFinished: false,
            createdAt: days(fromNow: -1),
            finishedAt: nil,
            onlineShop: [
                URL(string: "https://www.instacart.com")!,
                URL(string: "https://www.walmart.com")!
            ]
        ),
        ShoppingList(
            id: UUID(),
            name: "House Cleaning Supplies",
            amount: 10,
            createdBy: users[1],
            shops: [shops[1]],
            tags: [tags[1]],
            note: nil,
            deadlineDate: days(fromNow: 7),
            isFinished: false,
            createdAt: days(fromNow: -3),
            finishedAt: nil,
            onlineShop: [
                URL(string: "https://www.amazon.com")!
            ]
        ),
        ShoppingList(
            id: UUID(),
            name: "Pet Food Restock",
            amount: 6,
            createdBy: users[0],
            shops: [shops[2]],
            tags: [tags[2]],
            note: "Get the grain-free kind.",
            deadlineDate: nil,
            isFinished: true,
            createdAt: days(fromNow: -14),
            finishedAt: days(fromNow: -7),
            onlineShop: []
        ),
        ShoppingList(
            id: UUID(),
            name: "Pet Food Restock",
            amount: 6,
            createdBy: users[0],
            shops: [shops[2]],
            tags: [tags[2]],
            note: "Get the grain-free kind.",
            deadlineDate: nil,
            isFinished: true,
            createdAt: days(fromNow: -14),
            finishedAt: days(fromNow: -7),
            onlineShop: []
        ),
        ShoppingList(
            id: UUID(),
            name: "House Cleaning Supplies",
            amount: 10,
            createdBy: users[1],
            shops: [shops[1]],
            tags: [tags[1]],
            note: nil,
            deadlineDate: days(fromNow: 7),
            isFinished: false,
            createdAt: days(fromNow: -3),
            finishedAt: nil,
            onlineShop: [
                URL(string: "https://www.amazon.com")!
            ]
        ),
        ShoppingList(
            id: UUID(),
            name: "Pet Food Restock",
            amount: 6,
            createdBy: users[0],
            shops: [shops[2]],
            tags: [tags[2]],
            note: "Get the grain-free kind.",
            deadlineDate: nil,
            isFinished: true,
            createdAt: days(fromNow: -14),
            finishedAt: days(fromNow: -7),
            onlineShop: []
        ),
        ShoppingList(
            id: UUID(),
            name: "Pet Food Restock",
            amount: 6,
            createdBy: users[0],
            shops: [shops[2]],
            tags: [tags[2]],
            note: "Get the grain-free kind.",
            deadlineDate: nil,
            isFinished: true,
            createdAt: days(fromNow: -14),
            finishedAt: days(fromNow: -7),
            onlineShop: []
        ),
        ShoppingList(
            id: UUID(),
            name: "House Cleaning Supplies",
            amount: 10,
            createdBy: users[1],
            shops: [shops[1]],
            tags: [tags[1]],
            note: nil,
            deadlineDate: days(fromNow: 7),
            isFinished: false,
            createdAt: days(fromNow: -3),
            finishedAt: nil,
            onlineShop: [
                URL(string: "https://www.amazon.com")!
            ]
        ),
        ShoppingList(
            id: UUID(),
            name: "Pet Food Restock",
            amount: 6,
            createdBy: users[0],
            shops: [shops[2]],
            tags: [tags[2]],
            note: "Get the grain-free kind.",
            deadlineDate: nil,
            isFinished: true,
            createdAt: days(fromNow: -14),
            finishedAt: days(fromNow: -7),
            onlineShop: []
        ),
        ShoppingList(
            id: UUID(),
            name: "Pet Food Restock",
            amount: 6,
            createdBy: users[0],
            shops: [shops[2]],
            tags: [tags[2]],
            note: "Get the grain-free kind.",
            deadlineDate: nil,
            isFinished: true,
            createdAt: days(fromNow: -14),
            finishedAt: days(fromNow: -7),
            onlineShop: []
        ),
        ShoppingList(
            id: UUID(),
            name: "House Cleaning Supplies",
            amount: 10,
            createdBy: users[1],
            shops: [shops[1]],
            tags: [tags[1]],
            note: nil,
            deadlineDate: days(fromNow: 7),
            isFinished: false,
            createdAt: days(fromNow: -3),
            finishedAt: nil,
            onlineShop: [
                URL(string: "https://www.amazon.com")!
            ]
        ),
        ShoppingList(
            id: UUID(),
            name: "Pet Food Restock",
            amount: 6,
            createdBy: users[0],
            shops: [shops[2]],
            tags: [tags[2]],
            note: "Get the grain-free kind.",
            deadlineDate: nil,
            isFinished: true,
            createdAt: days(fromNow: -14),
            finishedAt: days(fromNow: -7),
            onlineShop: []
        ),
        ShoppingList(
            id: UUID(),
            name: "Pet Food Restock",
            amount: 6,
            createdBy: users[0],
            shops: [shops[2]],
            tags: [tags[2]],
            note: "Get the grain-free kind.",
            deadlineDate: nil,
            isFinished: true,
            createdAt: days(fromNow: -14),
            finishedAt: days(fromNow: -7),
            onlineShop: []
        ),
        ShoppingList(
            id: UUID(),
            name: "House Cleaning Supplies",
            amount: 10,
            createdBy: users[1],
            shops: [shops[1]],
            tags: [tags[1]],
            note: nil,
            deadlineDate: days(fromNow: 7),
            isFinished: false,
            createdAt: days(fromNow: -3),
            finishedAt: nil,
            onlineShop: [
                URL(string: "https://www.amazon.com")!
            ]
        ),
        ShoppingList(
            id: UUID(),
            name: "Pet Food Restock",
            amount: 6,
            createdBy: users[0],
            shops: [shops[2]],
            tags: [tags[2]],
            note: "Get the grain-free kind.",
            deadlineDate: nil,
            isFinished: true,
            createdAt: days(fromNow: -14),
            finishedAt: days(fromNow: -7),
            onlineShop: []
        ),
        ShoppingList(
            id: UUID(),
            name: "Pet Food Restock",
            amount: 6,
            createdBy: users[0],
            shops: [shops[2]],
            tags: [tags[2]],
            note: "Get the grain-free kind.",
            deadlineDate: nil,
            isFinished: true,
            createdAt: days(fromNow: -14),
            finishedAt: days(fromNow: -7),
            onlineShop: []
        ),
        ShoppingList(
            id: UUID(),
            name: "House Cleaning Supplies",
            amount: 10,
            createdBy: users[1],
            shops: [shops[1]],
            tags: [tags[1]],
            note: nil,
            deadlineDate: days(fromNow: 7),
            isFinished: false,
            createdAt: days(fromNow: -3),
            finishedAt: nil,
            onlineShop: [
                URL(string: "https://www.amazon.com")!
            ]
        ),
        ShoppingList(
            id: UUID(),
            name: "Pet Food Restock",
            amount: 6,
            createdBy: users[0],
            shops: [shops[2]],
            tags: [tags[2]],
            note: "Get the grain-free kind.",
            deadlineDate: nil,
            isFinished: true,
            createdAt: days(fromNow: -14),
            finishedAt: days(fromNow: -7),
            onlineShop: []
        ),
        ShoppingList(
            id: UUID(),
            name: "Pet Food Restock",
            amount: 6,
            createdBy: users[0],
            shops: [shops[2]],
            tags: [tags[2]],
            note: "Get the grain-free kind.",
            deadlineDate: nil,
            isFinished: true,
            createdAt: days(fromNow: -14),
            finishedAt: days(fromNow: -7),
            onlineShop: []
        ),
        ShoppingList(
            id: UUID(),
            name: "House Cleaning Supplies",
            amount: 10,
            createdBy: users[1],
            shops: [shops[1]],
            tags: [tags[1]],
            note: nil,
            deadlineDate: days(fromNow: 7),
            isFinished: false,
            createdAt: days(fromNow: -3),
            finishedAt: nil,
            onlineShop: [
                URL(string: "https://www.amazon.com")!
            ]
        ),
        ShoppingList(
            id: UUID(),
            name: "Pet Food Restock",
            amount: 6,
            createdBy: users[0],
            shops: [shops[2]],
            tags: [tags[2]],
            note: "Get the grain-free kind.",
            deadlineDate: nil,
            isFinished: true,
            createdAt: days(fromNow: -14),
            finishedAt: days(fromNow: -7),
            onlineShop: []
        ),
        ShoppingList(
            id: UUID(),
            name: "Pet Food Restock",
            amount: 6,
            createdBy: users[0],
            shops: [shops[2]],
            tags: [tags[2]],
            note: "Get the grain-free kind.",
            deadlineDate: nil,
            isFinished: true,
            createdAt: days(fromNow: -14),
            finishedAt: days(fromNow: -7),
            onlineShop: []
        ),
        ShoppingList(
            id: UUID(),
            name: "House Cleaning Supplies",
            amount: 10,
            createdBy: users[1],
            shops: [shops[1]],
            tags: [tags[1]],
            note: nil,
            deadlineDate: days(fromNow: 7),
            isFinished: false,
            createdAt: days(fromNow: -3),
            finishedAt: nil,
            onlineShop: [
                URL(string: "https://www.amazon.com")!
            ]
        ),
        ShoppingList(
            id: UUID(),
            name: "Pet Food Restock",
            amount: 6,
            createdBy: users[0],
            shops: [shops[2]],
            tags: [tags[2]],
            note: "Get the grain-free kind.",
            deadlineDate: nil,
            isFinished: true,
            createdAt: days(fromNow: -14),
            finishedAt: days(fromNow: -7),
            onlineShop: []
        ),
        ShoppingList(
            id: UUID(),
            name: "Pet Food Restock",
            amount: 6,
            createdBy: users[0],
            shops: [shops[2]],
            tags: [tags[2]],
            note: "Get the grain-free kind.",
            deadlineDate: nil,
            isFinished: true,
            createdAt: days(fromNow: -14),
            finishedAt: days(fromNow: -7),
            onlineShop: []
        ),
        ShoppingList(
            id: UUID(),
            name: "House Cleaning Supplies",
            amount: 10,
            createdBy: users[1],
            shops: [shops[1]],
            tags: [tags[1]],
            note: nil,
            deadlineDate: days(fromNow: 7),
            isFinished: false,
            createdAt: days(fromNow: -3),
            finishedAt: nil,
            onlineShop: [
                URL(string: "https://www.amazon.com")!
            ]
        ),
        ShoppingList(
            id: UUID(),
            name: "Pet Food Restock",
            amount: 6,
            createdBy: users[0],
            shops: [shops[2]],
            tags: [tags[2]],
            note: "Get the grain-free kind.",
            deadlineDate: nil,
            isFinished: true,
            createdAt: days(fromNow: -14),
            finishedAt: days(fromNow: -7),
            onlineShop: []
        ),
        ShoppingList(
            id: UUID(),
            name: "Pet Food Restock",
            amount: 6,
            createdBy: users[0],
            shops: [shops[2]],
            tags: [tags[2]],
            note: "Get the grain-free kind.",
            deadlineDate: nil,
            isFinished: true,
            createdAt: days(fromNow: -14),
            finishedAt: days(fromNow: -7),
            onlineShop: []
        ),
        ShoppingList(
            id: UUID(),
            name: "House Cleaning Supplies",
            amount: 10,
            createdBy: users[1],
            shops: [shops[1]],
            tags: [tags[1]],
            note: nil,
            deadlineDate: days(fromNow: 7),
            isFinished: false,
            createdAt: days(fromNow: -3),
            finishedAt: nil,
            onlineShop: [
                URL(string: "https://www.amazon.com")!
            ]
        ),
        ShoppingList(
            id: UUID(),
            name: "Pet Food Restock",
            amount: 6,
            createdBy: users[0],
            shops: [shops[2]],
            tags: [tags[2]],
            note: "Get the grain-free kind.",
            deadlineDate: nil,
            isFinished: true,
            createdAt: days(fromNow: -14),
            finishedAt: days(fromNow: -7),
            onlineShop: []
        ),
        ShoppingList(
            id: UUID(),
            name: "Pet Food Restock",
            amount: 6,
            createdBy: users[0],
            shops: [shops[2]],
            tags: [tags[2]],
            note: "Get the grain-free kind.",
            deadlineDate: nil,
            isFinished: true,
            createdAt: days(fromNow: -14),
            finishedAt: days(fromNow: -7),
            onlineShop: []
        ),
    ]
    
    static let shoppingList: ShoppingList = shoppingLists[0]
    
    // MARK: - Date Helpers
    static func days(fromNow days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: days, to: Date()) ?? Date()
    }
}
#endif
