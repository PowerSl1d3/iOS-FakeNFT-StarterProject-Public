//
//  ProfileService.swift
//  FakeNFT
//
//  Created by Алия Давлетова on 23.10.2023.
//

import Foundation

protocol ProfileServiceProtocol {
    func getProfile(profileID: String, _ handler: @escaping (Result<Profile, Error>) -> Void)
    func updateProfile(profile: Profile)
}

struct GetProfileRequest: NetworkRequest {
    var endpoint: URL?
    
    init(profileID: String) {
        self.endpoint = URL(string: "\(baseURL)/api/v1/profile/\(profileID)")
    }
}

struct UpdateUserRequest: NetworkRequest {
    var endpoint: URL?
    
    init(profile: Profile) {
        self.endpoint = URL(string: "")
    }
}

final class ProfileService: ProfileServiceProtocol {
    let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func getProfile(profileID: String, _ handler: @escaping (Result<Profile, Error>) -> Void) {
        let req = GetProfileRequest(profileID: profileID)
        
        networkClient.send(request: req, type: Profile.self) { [weak self] (result: Result<Profile, Error>) in
            guard let self = self else {
                assertionFailure("getProfile: self is empty")
                return
            }

            handler(result)
        }
    }
    
    func updateProfile(profile: Profile) {
        
    }
}
