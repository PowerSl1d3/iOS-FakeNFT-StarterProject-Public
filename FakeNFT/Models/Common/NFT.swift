//
//  NFT.swift
//  FakeNFT
//
//  Created by Олег Аксененко on 10.10.2023.
//

struct NFT: Codable {
    let id: String
    let name: String
    let images: [String]
    let rating: Int
    let price: Double
}
