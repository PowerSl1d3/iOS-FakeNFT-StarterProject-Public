//
//  NFTCollectionPresenter.swift
//  FakeNFT
//
//  Created by Алия Давлетова on 21.10.2023.
//

import Foundation

protocol NFTCollectionPresenterDelegateProtocol: AnyObject {
    func showAlert(alert: AlertModel)
    func reloadData()
    func reloadCell(by indexPath: IndexPath)
    
    
//    func loadUserStarted()
//    func loadUserFinished()
}

protocol NFTCollectionPresenterProtocol {
    var nftViewModels: [NFTViewModel] { get }
    
    func loadData(nftIDs: [String])
    func likeNFT(isLike: Bool, indexPath: IndexPath)
}

final class NFTCollectionPresenter: NFTCollectionPresenterProtocol {
    var nftViewModels: [NFTViewModel] = []
    var profile: Profile?
    var likes: Set<String> = []
    
    var nftService: NFTServiceProtocol
    var profileService: ProfileServiceProtocol
    weak var delegate: NFTCollectionPresenterDelegateProtocol?
    
    init(nftService: NFTServiceProtocol, profileService: ProfileServiceProtocol) {
        self.nftService = nftService
        self.profileService = profileService
    }
    
    func loadData(nftIDs: [String]) {
        var nfts: [NFT] = []
        
        let group = DispatchGroup()
        
        group.enter()
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
                self.likes = Set(profile.likes)
            }
            
            group.leave()
        }

        
        for nftID in nftIDs {
            group.enter()
            nftService.getNFT(id: nftID) { (result: Result<NFT, Error>) in
                switch result {
                case .failure(let error):
                    print("failed to load nft \(nftID) with error: \(error)")
                case .success(let nft):
                    nfts.append(nft)
                }
                
                group.leave()
                
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let self = self else {
                assertionFailure("listNFTs: self is empty")
                return
            }
            
            self.nftViewModels = nfts.map{ self.nftToViewModel(from: $0) }
            self.delegate?.reloadData()
        }
    }
    
    func likeNFT(isLike: Bool, indexPath: IndexPath) {
        guard var updateProfile = profile else {
            assertionFailure("likeNFT: profile is empty")
            return
        }
        
        if isLike {
            updateProfile.likes.append(nftViewModels[indexPath.row].nft.id)
        } else {
            updateProfile.likes.removeAll(where: { $0 == nftViewModels[indexPath.row].nft.id })
        }
        
        profileService.updateProfile(profile: updateProfile) { (result: Result<Profile, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    //TODO: show alert
                    print("failed to update profile with error \(error)")
                    return
                case .success(let newProfile):
                    print("!!!!!  succes !!!!!!!!!!")
                    print(newProfile)
                    self.profile = newProfile
                    self.nftViewModels[indexPath.row].isLike = isLike
                    self.likes = Set(newProfile.likes)
                    self.delegate?.reloadCell(by: indexPath)
                }
            }
        }
    }
    
    private func nftToViewModel(from nft: NFT) -> NFTViewModel {
        let nftVM = NFTViewModel(nft: nft, isLike: likes.contains(nft.id), inOrder: false)
        
        return nftVM
    }
}
