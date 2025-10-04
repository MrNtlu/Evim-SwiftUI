//
//  ShoppingListViewCell.swift
//  Evim
//
//  Created by Burak on 2025/10/04.
//

import SwiftUI

struct ShoppingModeListViewCell: View {
    
    let itemBinding: Binding<ShoppingList>
    
    var body: some View {
        HStack {
            Text(itemBinding.wrappedValue.name)
                .overlay(alignment: .center) {
                    if itemBinding.isFinished.wrappedValue {
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.black)
                            .offset(y: 1)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)

            Button(action: {
                itemBinding.isFinished.wrappedValue.toggle()
            }) {
                Image(systemName: itemBinding.isFinished.wrappedValue ? "checkmark.square.fill" : "square")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(itemBinding.isFinished.wrappedValue ? .accentColor : .secondary)
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    ShoppingModeListViewCell(itemBinding: .constant(MockData.shoppingList))
}
