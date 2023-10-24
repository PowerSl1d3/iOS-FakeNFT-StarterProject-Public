//
//  NFTCollectionPresenter.swift
//  FakeNFT
//
//  Created by Алия Давлетова on 21.10.2023.
//

import Foundation

protocol NFTCollectionPresenterDelegateProtocol: AnyObject {
    func showAlert(alert: AlertModel)
    func setNFTs(nfts: [NFT])
    func reloadData()
    
    
//    func loadUserStarted()
//    func loadUserFinished()
}

protocol NFTCollectionPresenterProtocol {
    func listNFTs(nftIDs: [String])
}

final class NFTCollectionPresenter: NFTCollectionPresenterProtocol {
    var profile: Profile?
    
    var nftService: NFTServiceProtocol
    var profileService: ProfileServiceProtocol
    weak var delegate: NFTCollectionPresenterDelegateProtocol?
    
    init(nftService: NFTServiceProtocol, profileService: ProfileServiceProtocol) {
        self.nftService = nftService
        self.profileService = profileService
        
        //TODO: вынести айди профайла
        profileService.getProfile(profileID: "1") { (result: Result<Profile, Error>) in
            switch result {
            case .failure(let error):
                print("failed to get profile \(error)")
                //TODO: show alert
                return
            case .success(let profile):
                print(profile)
                self.profile = profile
            }
        }
    }
    
    func listNFTs(nftIDs: [String]) {
        var nfts: [NFT] = []
        
        let group = DispatchGroup()
        
        for nftID in nftIDs {
            print("start load \(nftID)")
            
            group.enter()
            nftService.getNFT(id: nftID) { (result: Result<NFT, Error>) in
                print("finish load \(nftID)")
                
                switch result {
                case .failure(let error):
                    print("failed to load nft \(nftID) with error: \(error)")
                case .success(let nft):
                    nfts.append(nft)
                }
                
                print("before leave finish load \(nftID)")
                
                group.leave()
                
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            print("finish load all")
            
            guard let self = self else {
                assertionFailure("listNFTs: self is empty")
                return
            }
            self.delegate?.setNFTs(nfts: nfts)
            self.delegate?.reloadData()
        }
    }
}
