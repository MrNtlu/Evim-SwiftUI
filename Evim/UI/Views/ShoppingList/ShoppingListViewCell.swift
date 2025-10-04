//
//  ShoppingListViewCell.swift
//  Evim
//
//  Created by Burak on 2025/10/04.
//

import SwiftUI

struct ShoppingListViewCell: View {
    let item: ShoppingList
    
    var body: some View {
        HStack {
            Text(item.name)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    ShoppingListViewCell(item: MockData.shoppingList)
}
