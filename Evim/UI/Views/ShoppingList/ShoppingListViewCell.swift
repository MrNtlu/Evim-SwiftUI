//
//  ShoppingListViewCell.swift
//  Evim
//
//  Created by Burak on 2025/10/04.
//

import SwiftUI

struct ShoppingListViewCell: View {
    let item: ShoppingListItem
    let productStore: ProductStore
    let onEdit: ((ShoppingListItem) -> Void)?
    let onDelete: (() -> Void)?
    @State private var showDetailSheet = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Name
            Text(item.name(from: productStore))
                .font(.headline)

            // Tags (compact chips)
            if !item.tags(from: productStore).isEmpty {
                ShoppingListCellTagRow(tags: item.tags(from: productStore))
                    .equatable()
            }

            // Icons row (compact)
            ShoppingListCellIconsRow(
                deadline: item.deadlineDate,
                amount: item.amount,
                unit: item.unit,
                hasNote: item.note != nil
            )
            .equatable()
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .onTapGesture {
            showDetailSheet = true
        }
        .sheet(isPresented: $showDetailSheet) {
            ShoppingListItemDetailSheet(
                item: item,
                productStore: productStore,
                isPresented: $showDetailSheet,
                onEdit: onEdit,
                onDelete: onDelete
            )
        }
        .id(item.id)
    }
}

// MARK: - Subviews

struct ShoppingListCellTagRow: View, Equatable {
    let tags: [Tag]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 6) {
                ForEach(tags) { tag in
                    HStack(spacing: 4) {
                        Text(tag.emoji)
                            .font(.caption2)
                        Text(tag.label)
                            .font(.caption)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(hex: tag.color).opacity(0.2))
                    .cornerRadius(8)
                }
            }
        }
    }
}

struct ShoppingListCellIconsRow: View, Equatable {
    let deadline: Date?
    let amount: Double
    let unit: MeasurementUnit
    let hasNote: Bool

    var body: some View {
        HStack(spacing: 12) {
            // Amount text without icon
            Text(formatAmount(amount, unit: unit))
                .font(.caption)
                .foregroundStyle(.secondary)

            // Separator
            if deadline != nil {
                Text("•")
                    .font(.caption)
                    .foregroundStyle(.secondary.opacity(0.5))
            }

            // Deadline text without icon
            if let deadline = deadline {
                Text(Date.smartFormat(deadline))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            // Note indicator (rightmost, text)
            if hasNote {
                Text("Note")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func formatAmount(_ amount: Double, unit: MeasurementUnit) -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        let amountString = formatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
        return "\(amountString) \(unit.abbreviation)"
    }
}

#Preview {
    @Previewable @State var productStore = ProductStore()

    List {
        ShoppingListViewCell(
            item: MockData.shoppingList,
            productStore: productStore,
            onEdit: { _ in },
            onDelete: { }
        )
    }
}
