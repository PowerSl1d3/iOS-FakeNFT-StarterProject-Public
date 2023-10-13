import Foundation

struct Profile: Decodable, Equatable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [String]
    let likes: [String]
    let id: String
}

extension Profile {
    init() {
        self.name = ""
        self.avatar = ""
        self.description = ""
        self.website = ""
        self.nfts = []
        self.likes = []
        self.id = ""
    }
}

struct ProfileLikes: Encodable {
    let likes: [String]
}
