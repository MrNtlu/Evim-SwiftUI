//
//  Tag.swift
//  Evim
//
//  Created by Burak on 2025/10/03.
//

import Foundation

struct Tag: Codable, Identifiable, Equatable {
    let id: UUID
    let color: String //hexcode
    let emoji: String
    let label: String

    init(id: UUID = UUID(), color: String, emoji: String, label: String) {
        self.id = id
        self.color = color
        self.emoji = emoji
        self.label = label
    }

    static func == (lhs: Tag, rhs: Tag) -> Bool {
        lhs.id == rhs.id &&
        lhs.color == rhs.color &&
        lhs.emoji == rhs.emoji &&
        lhs.label == rhs.label
    }
}
