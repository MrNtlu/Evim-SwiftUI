//
//  ShoppingListViewBottomButtons.swift
//  Evim
//
//  Created by Burak on 2025/10/04.
//

import SwiftUI

struct ShoppingListViewBottomButtons: View {
    @Binding var isShoppingMode: Bool
    var onFinishShopping: () -> Void
    var onAddItem: () -> Void
    var onSelectProduct: (() -> Void)?
    var onManualEntry: (() -> Void)?
    var onStartShopping: () -> Bool // Returns true if can start, false if validation fails

    @Environment(ThemeStore.self) private var themeStore
    @State private var showFinishAlert = false
    @State private var showCancelAlert = false
    private let chipHeight: CGFloat = 42

    var body: some View {
        HStack(spacing: 6) {
            //Main Button
            Button {
                if isShoppingMode {
                    showFinishAlert = true
                } else {
                    // Validate before starting shopping
                    if onStartShopping() {
                        withAnimation(.smooth(duration: 0.3)) {
                            isShoppingMode = true
                        }
                    }
                }
            } label: {
                HStack {
                    Image(systemName: isShoppingMode ? "creditcard" : "cart")
                        .contentTransition(.symbolEffect(.replace))
                        .padding()

                    Text(isShoppingMode ? "Finish Shopping" : "Start Shopping")
                        .font(.headline)
                        .contentTransition(.numericText())
                }
                .frame(maxWidth: .infinity)
                .frame(height: 42)
            }
            .buttonStyle(.glass)
            .tint(.primary)
            .geometryGroup()
            .animation(.smooth(duration: 0.3), value: isShoppingMode)
            .alert("Finish Shopping", isPresented: $showFinishAlert) {
                Button("Yes", role: .destructive) {
                    withAnimation(.smooth(duration: 0.3)) {
                        onFinishShopping()
                        isShoppingMode = false
                    }
                }
                
                Button("Cancel", role: .cancel) {
                    
                }
            } message: {
                Text("Do you want to finish and save your shopping?")
            }

            //Fab Button
            if isShoppingMode {
                Button {
                    showCancelAlert = true
                } label: {
                    Image(systemName: "xmark")
                        .contentTransition(.symbolEffect(.replace))
                        .font(.system(size: 24, weight: .semibold))
                        .frame(width: chipHeight, height: chipHeight)
                }
                .buttonStyle(.glassProminent)
                .tint(Color.red)
                .alert("Discard Changes", isPresented: $showCancelAlert) {
                    Button("Cancel Shopping", role: .destructive) {
                        withAnimation(.smooth(duration: 0.3)) {
                            isShoppingMode = false
                        }
                    }

                    Button("Keep Shopping", role: .cancel) {
                    }
                } message: {
                    Text("Do you want to cancel shopping?")
                }
                .clipShape(Circle())
                .shadow(color: Color.red.opacity(0.4), radius: 10, x: 0, y: 2)
                .geometryGroup()
                .animation(.smooth(duration: 0.3), value: isShoppingMode)
            } else {
                Menu {
                    Button {
                        onSelectProduct?()
                    } label: {
                        Label {
                            Text("Select Product")
                                .foregroundStyle(.primary)
                        } icon: {
                            Image(systemName: "list.bullet")
                                .foregroundStyle(.primary)
                        }
                    }

                    Button {
                        onManualEntry?()
                    } label: {
                        Label {
                            Text("Manual Entry")
                                .foregroundStyle(.primary)
                        } icon: {
                            Image(systemName: "pencil")
                                .foregroundStyle(.primary)
                        }
                    }
                } label: {
                    Image(systemName: "plus")
                        .contentTransition(.symbolEffect(.replace))
                        .font(.system(size: 24, weight: .semibold))
                        .frame(width: chipHeight, height: chipHeight)
                }
                .buttonStyle(.glassProminent)
                .tint(themeStore.accentColor)
                .clipShape(Circle())
                .shadow(color: themeStore.accentColor.opacity(0.4), radius: 10, x: 0, y: 2)
                .geometryGroup()
                .animation(.smooth(duration: 0.3), value: isShoppingMode)
            }
        }
    }
}

#Preview {
    @Previewable @State var themeStore = ThemeStore()

    VStack {
        ShoppingListViewBottomButtons(
            isShoppingMode: .constant(false),
            onFinishShopping: {},
            onAddItem: {},
            onSelectProduct: {},
            onManualEntry: {},
            onStartShopping: { true }
        )
        .environment(themeStore)

        ShoppingListViewBottomButtons(
            isShoppingMode: .constant(true),
            onFinishShopping: {},
            onAddItem: {},
            onSelectProduct: {},
            onManualEntry: {},
            onStartShopping: { true }
        )
        .environment(themeStore)
    }
}
