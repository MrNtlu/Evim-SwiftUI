//
//  Shop.swift
//  Evim
//
//  Created by Burak on 2025/10/03.
//

import Foundation

struct Shop: Decodable {
    let id: UUID
    let name: String
    let createdAt: Date
    // LatLng or GMaps Link
}
