//
//  ShoppingListItem.swift
//  Evim
//
//  Created by Burak on 2025/10/03.
//

import Foundation

struct ShoppingListItem: Codable, Identifiable, Equatable {
    let id: UUID
    let createdBy: User
    let createdAt: Date

    // === Source (mutually exclusive) ===
    let productId: UUID?        // Live reference to Product
    var manualName: String?     // Only if not from product
    var manualTags: [Tag]?      // Only if not from product

    // === User Fields (always editable) ===
    var amount: Double
    var unit: MeasurementUnit
    var note: String?
    var deadlineDate: Date?
    var isFinished: Bool
    var finishedAt: Date?

    // === Shopping Details (filled during shopping mode) ===
    var amountPurchased: Double?
    var shopPurchasedAt: String?
    var pricePaid: Double?
    var priceCurrency: Currency?

    // === Computed Properties ===
    var isFromProduct: Bool {
        productId != nil
    }

    // === Helper Methods (require ProductStore) ===
    @MainActor
    func name(from productStore: ProductStore) -> String {
        if let productId = productId,
           let product = productStore.product(id: productId) {
            return product.name
        }
        return manualName ?? ""
    }

    @MainActor
    func tags(from productStore: ProductStore) -> [Tag] {
        if let productId = productId,
           let product = productStore.product(id: productId) {
            return product.tags ?? []
        }
        return manualTags ?? []
    }

    // === Factory Methods ===
    static func fromProduct(
        _ product: Product,
        amount: Double,
        unit: MeasurementUnit,
        createdBy: User,
        note: String? = nil,
        deadline: Date? = nil
    ) -> ShoppingListItem {
        ShoppingListItem(
            id: UUID(),
            createdBy: createdBy,
            createdAt: Date(),
            productId: product.id,
            manualName: nil,
            manualTags: nil,
            amount: amount,
            unit: unit,
            note: note,
            deadlineDate: deadline,
            isFinished: false,
            finishedAt: nil,
            amountPurchased: nil,
            shopPurchasedAt: nil,
            pricePaid: nil,
            priceCurrency: nil
        )
    }

    static func manual(
        name: String,
        amount: Double,
        unit: MeasurementUnit,
        tags: [Tag],
        createdBy: User,
        note: String? = nil,
        deadline: Date? = nil
    ) -> ShoppingListItem {
        ShoppingListItem(
            id: UUID(),
            createdBy: createdBy,
            createdAt: Date(),
            productId: nil,
            manualName: name,
            manualTags: tags,
            amount: amount,
            unit: unit,
            note: note,
            deadlineDate: deadline,
            isFinished: false,
            finishedAt: nil,
            amountPurchased: nil,
            shopPurchasedAt: nil,
            pricePaid: nil,
            priceCurrency: nil
        )
    }

    // === Equatable ===
    static func == (lhs: ShoppingListItem, rhs: ShoppingListItem) -> Bool {
        lhs.id == rhs.id &&
        lhs.productId == rhs.productId &&
        lhs.manualName == rhs.manualName &&
        lhs.manualTags == rhs.manualTags &&
        lhs.amount == rhs.amount &&
        lhs.unit == rhs.unit &&
        lhs.isFinished == rhs.isFinished &&
        lhs.note == rhs.note &&
        lhs.deadlineDate == rhs.deadlineDate
    }
}
