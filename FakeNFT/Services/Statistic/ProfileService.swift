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
    var endpoint: URL?
    
    init(profileID: String) {
        guard let url = URL(string: "\(getProfilePath)/\(profileID)", relativeTo: baseURL) else {
            assertionFailure("failed to create url from baseURL: \(String(describing: baseURL?.absoluteString)), path: \(getProfilePath)")
            return
        }

        self.endpoint = url
    }
}

struct UpdateUserRequest: NetworkRequest {
    var endpoint: URL?
    
    init(updateProfile: Profile) {
        guard let url = URL(string: updateProfilePath, relativeTo: baseURL) else {
            assertionFailure("failed to create url from baseURL: \(String(describing: baseURL?.absoluteString)), path: \(updateProfilePath)")
            return
        }
        
        var urlComponents = URLComponents(string: url.absoluteString)

        let likesQueryItem = updateProfile.likes.map { URLQueryItem(name: "likes", value: $0) }
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "name", value: updateProfile.name),
            URLQueryItem(name: "description", value: updateProfile.description),
            URLQueryItem(name: "website", value: updateProfile.website),
        ]
        queryItems.append(contentsOf: likesQueryItem)
        
        urlComponents?.queryItems = queryItems
        
        endpoint = urlComponents?.url
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
    
    func updateProfile(profile: Profile, _ handler: @escaping (Result<Profile, Error>) -> Void) {
        let req = UpdateUserRequest(updateProfile: profile)
        
        networkClient.send(request: req, type: Profile.self) { [weak self] (result: Result<Profile, Error>) in
            guard let self = self else {
                assertionFailure("getProfile: self is empty")
                return
            }

            handler(result)
        }
    }
}
