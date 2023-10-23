//
//  NFTService.swift
//  FakeNFT
//
//  Created by Алия Давлетова on 21.10.2023.
//

import Foundation

protocol NFTServiceProtocol {
    func getNFT(id: String, _ handler: @escaping(Result<NFT, Error>) -> Void)
}

struct GetNFTRequest: NetworkRequest {
    var endpoint: URL?
    
    init(nftID: String) {
        endpoint = URL(string: "https://64858e8ba795d24810b71189.mockapi.io/api/v1/nft/\(nftID)")
    }
}

final class NFTService: NFTServiceProtocol {
    let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func getNFT(id: String, _ handler: @escaping (Result<NFT, Error>) -> Void) {
        let req = GetNFTRequest(nftID: id)
        
        networkClient.send(request: req, type: NFT.self) { [weak self] (result: Result<NFT, Error>) in
            guard let self = self else {
                assertionFailure("getNFT: self is empty")
                return
            }

            handler(result)
        }
    }
}
