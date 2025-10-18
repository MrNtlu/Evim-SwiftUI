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
        Tag(color: "#FFD93D", emoji: "🐶", label: "Pet"),
        Tag(color: "#9B59B6", emoji: "💊", label: "Health"),
        Tag(color: "#45B7D1", emoji: "🏠", label: "Home"),
        Tag(color: "#FF8787", emoji: "👕", label: "Clothing"),
        Tag(color: "#52B788", emoji: "🪴", label: "Garden"),
        Tag(color: "#FFB347", emoji: "🔧", label: "Tools")
    ]

    static let tag: Tag = tags[0]

    // MARK: - Products
    static let products: [Product] = [
        Product(
            id: UUID(),
            name: "Organic Milk",
            note: "Fresh organic milk",
            tags: [tags[0]],
            createdAt: days(fromNow: -60),
            createdBy: users[0]
        ),
        Product(
            id: UUID(),
            name: "Whole Wheat Bread",
            note: nil,
            tags: [tags[0]],
            createdAt: days(fromNow: -55),
            createdBy: users[0]
        ),
        Product(
            id: UUID(),
            name: "Free Range Eggs",
            note: "Dozen eggs",
            tags: [tags[0]],
            createdAt: days(fromNow: -50),
            createdBy: users[0]
        ),
        Product(
            id: UUID(),
            name: "All-Purpose Cleaner",
            note: nil,
            tags: [tags[1]],
            createdAt: days(fromNow: -45),
            createdBy: users[1]
        ),
        Product(
            id: UUID(),
            name: "Dish Soap",
            note: nil,
            tags: [tags[1]],
            createdAt: days(fromNow: -40),
            createdBy: users[1]
        ),
        Product(
            id: UUID(),
            name: "Dog Food",
            note: "Grain-free premium",
            tags: [tags[2]],
            createdAt: days(fromNow: -35),
            createdBy: users[0]
        )
    ]

    static let product: Product = products[0]

    // MARK: - Shopping Lists
    static let shoppingLists: [ShoppingListItem] = [
        // Item from product
        ShoppingListItem(
            id: UUID(),
            createdBy: users[0],
            createdAt: days(fromNow: -1),
            productId: products[0].id,  // Organic Milk
            manualName: nil,
            manualTags: nil,
            amount: 2,
            unit: .liters,
            note: "Get the one with blue cap",
            deadlineDate: days(fromNow: 2),
            isFinished: false,
            finishedAt: nil,
            amountPurchased: nil,
            shopPurchasedAt: nil,
            pricePaid: nil,
            priceCurrency: nil
        ),
        // Manual entry
        ShoppingListItem(
            id: UUID(),
            createdBy: users[0],
            createdAt: days(fromNow: -1),
            productId: nil,
            manualName: "Fresh Strawberries",
            manualTags: [tags[0]],
            amount: 500,
            unit: .grams,
            note: "Check for ripeness",
            deadlineDate: days(fromNow: 2),
            isFinished: false,
            finishedAt: nil,
            amountPurchased: nil,
            shopPurchasedAt: nil,
            pricePaid: nil,
            priceCurrency: nil
        )
    ]

    static let shoppingList: ShoppingListItem = shoppingLists[0]

    // MARK: - Date Helpers
    static func days(fromNow days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: days, to: Date()) ?? Date()
    }
}
#endif
