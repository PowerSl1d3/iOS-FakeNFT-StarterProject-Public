//
//  User.swift
//  FakeNFT
//
//  Created by Алия Давлетова on 23.10.2023.
//

import Foundation

struct Profile: Codable {
    var name: String
    var avatarUrl: String
    var description: String
    var website: String
    var nfts: [String]
    var likes: [String]
    var id: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, website, likes, nfts
        case avatarUrl = "avatar"
    }
}
