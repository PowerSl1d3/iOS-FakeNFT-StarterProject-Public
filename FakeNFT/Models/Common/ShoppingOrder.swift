//
//  ShoppingOrder.swift
//  FakeNFT
//
//  Created by Олег Аксененко on 21.10.2023.
//

enum ShoppingBagSortType: String {
    case price
    case rating
    case name
}

struct ShoppingOrder: Codable {
    let nfts: [String]
    let id: String
}
