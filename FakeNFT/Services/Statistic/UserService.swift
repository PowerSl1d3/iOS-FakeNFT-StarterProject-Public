//
//  UserService.swift
//  FakeNFT
//
//  Created by Алия Давлетова on 12.10.2023.
//

import Foundation

protocol UserServiceProtocol {
    func listUser(
        usersPerPage: Int,
        nextPage: Int,
        sortParameter: UsersSortParameter,
        sortOrder: UsersSortOrder,
        _ handler: @escaping(Result<[User], Error>) -> Void
    ) -> Void
}

struct ListUsersRequest: NetworkRequest {
    private var path = "/api/v1/users"
    
    var endpoint: URL?
    
    init(nextPage: Int, usersPerPage: Int, sortParameter: UsersSortParameter, sortOrder: UsersSortOrder) {
        guard let url = URL(string: path, relativeTo: baseURL) else {
            assertionFailure("failed to create url from baseURL: \(String(describing: baseURL?.absoluteString)), path: \(path)")
            return
        }
        
        var urlComponents = URLComponents(string: url.absoluteString)
        
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "sortBy", value: sortParameter.rawValue),
            URLQueryItem(name: "order", value: sortOrder.rawValue),
            URLQueryItem(name: "page", value: nextPage.description),
            URLQueryItem(name: "limit", value: usersPerPage.description)
        ]
        
        urlComponents?.queryItems = queryItems
        
        endpoint = urlComponents?.url
    }
}

final class UserService: UserServiceProtocol {
    let networkClient: NetworkClient
    
    private var dataTask: NetworkTask?
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func listUser(
        usersPerPage: Int,
        nextPage: Int,
        sortParameter: UsersSortParameter,
        sortOrder: UsersSortOrder,
        _ handler: @escaping(Result<[User], Error>) -> Void
    ) {
        assert(Thread.isMainThread)
    
        if dataTask != nil {
            return
        }
                
        let req = ListUsersRequest(
            nextPage: nextPage,
            usersPerPage: usersPerPage,
            sortParameter: sortParameter,
            sortOrder: sortOrder
        )
     
        dataTask = networkClient.send(request: req, type: [User].self) {[weak self] (result: Result<[User], Error>) in
            guard let self = self else {
                assertionFailure("listUser: self is empty")
                return
            }
            
            self.dataTask = nil
            handler(result)
        }
    }
}
