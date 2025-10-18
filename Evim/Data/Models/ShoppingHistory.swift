//
//  ShoppingHistory.swift
//  Evim
//
//  Created by Burak on 2025/10/08.
//

import Foundation

struct ShoppingHistory: Codable, Identifiable, Equatable {
    let id: UUID
    let items: [ShoppingHistoryItem]  // Snapshots frozen at purchase time
    let doneBy: User
    let date: Date
    let totalSpent: Double?
    var isArchived: Bool = false

    // === Analytics ===
    var productsPurchased: [UUID] {
        items.compactMap { $0.productId }
    }

    var totalItemsPurchased: Double {
        items.compactMap { $0.amountPurchased }.reduce(0, +)
    }

    var totalItemsRequested: Double {
        items.reduce(0) { $0 + $1.amountRequested }
    }

    // === Factory: Create from completed shopping list ===
    @MainActor
    static func fromCompletedShoppingList(
        items: [ShoppingListItem],
        productStore: ProductStore,
        doneBy: User
    ) -> ShoppingHistory {
        // Create snapshots of finished items
        let historyItems = items
            .filter { $0.isFinished }
            .map { ShoppingHistoryItem.fromShoppingListItem($0, productStore: productStore) }

        // Calculate total spent
        let totalSpent = historyItems
            .compactMap { $0.pricePaid }
            .reduce(0, +)

        return ShoppingHistory(
            id: UUID(),
            items: historyItems,
            doneBy: doneBy,
            date: Date(),
            totalSpent: totalSpent > 0 ? totalSpent : nil,
            isArchived: false
        )
    }
}
