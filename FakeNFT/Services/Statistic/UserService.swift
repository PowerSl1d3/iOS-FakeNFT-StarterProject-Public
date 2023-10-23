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
    var endpoint: URL?
    
    init(nextPage: Int, usersPerPage: Int, sortParameter: UsersSortParameter, sortOrder: UsersSortOrder) {
        endpoint = URL(string: "https://651ff00f906e276284c3bfac.mockapi.io/api/v1/users" + "?sortBy=\(sortParameter.rawValue)&order=\(sortOrder.rawValue)&page=\(nextPage)&limit=\(usersPerPage)")
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
