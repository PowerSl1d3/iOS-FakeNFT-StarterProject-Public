//
//  ProfileService.swift
//  FakeNFT
//
//  Created by Алия Давлетова on 23.10.2023.
//

import Foundation

protocol ProfileServiceProtocol {
    func getProfile(profileID: String, _ handler: @escaping (Result<Profile, Error>) -> Void)
    func updateProfile(profile: Profile, _ handler: @escaping (Result<Profile, Error>) -> Void)
}

struct GetProfileRequest: NetworkRequest {
    private var path = "/api/v1/profile"
    
    var endpoint: URL?
    
    init(profileID: String) {
        guard let url = URL(string: "\(path)/\(profileID)", relativeTo: baseURL) else {
            assertionFailure("failed to create url from baseURL: \(String(describing: baseURL?.absoluteString)), path: \(path)")
            return
        }

        self.endpoint = url
    }
}

struct UpdateProfileRequest: NetworkRequest {
    private var path = "/api/v1/profile"
    
    var endpoint: URL?
    var httpMethod: HttpMethod
    var dto: Encodable?
    
    init(updateProfile: Profile) {
        self.httpMethod = .put
        self.dto = updateProfile
        
        guard let url = URL(string: "\(path)/\(updateProfile.id)", relativeTo: baseURL) else {
            assertionFailure("failed to create url from baseURL: \(String(describing: baseURL?.absoluteString)), path: \(path)")
            return
        }

        self.endpoint = url
    }
}

final class ProfileService: ProfileServiceProtocol {
    let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func getProfile(profileID: String, _ handler: @escaping (Result<Profile, Error>) -> Void) {
        let req = GetProfileRequest(profileID: profileID)
        
        networkClient.send(request: req, type: Profile.self) { (result: Result<Profile, Error>) in
            handler(result)
        }
    }
    
    func updateProfile(profile: Profile, _ handler: @escaping (Result<Profile, Error>) -> Void) {
        let req = UpdateProfileRequest(updateProfile: profile)
        
        networkClient.send(request: req, type: Profile.self) { (result: Result<Profile, Error>) in
            handler(result)
        }
    }
}
