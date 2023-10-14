//
//  RatingViewPresenter.swift
//  FakeNFT
//
//  Created by Алия Давлетова on 10.10.2023.
//

import Foundation

let usersPerPage = 20

enum ListUserError: Error {
    case unknownError
}

enum UsersSortParameter: String {
    case byName = "name"
    case byRating = "rating"
}

enum UsersSortOrder: String {
    case asc = "asc"
    case desc = "desc"
}

protocol RatingViewPresenterDelegate: AnyObject {    
    func showAlert(msg: String)
    func performBatchUpdates(indexPaths: [IndexPath])
    func reloadData()
    
    func loadUserStarted()
    func loadUserFinished()
}

final class RatingViewPresenter: RatingViewPresenterProtocol {
    private var sortParameter = UsersSortParameter.byRating
    private var sortOrder = UsersSortOrder.asc
    private var lastLoadedPage = 0
        
    private var service: UserServiceProtocol
    
    weak var delegate: RatingViewPresenterDelegate?
    
    var users: [User] = []

    init(networkClient: NetworkClient) {
        self.service = UserService(networkClient: networkClient)
    }
        
    func setDelegate(delegate: RatingViewPresenterDelegate) {
        self.delegate = delegate
    }
    
    func listUsers() {
        assert(Thread.isMainThread)
            
        let nextPage = lastLoadedPage + 1
        
        delegate?.loadUserStarted()
        
        service.listUser(
            usersPerPage: usersPerPage,
            nextPage: nextPage,
            sortParameter: sortParameter,
            sortOrder: sortOrder
        ) { [weak self] (result: Result<[User], Error>) in
            DispatchQueue.main.async {
                guard let self = self else {
                    assertionFailure("send request: self is empty")
                    return
                }
                
                self.delegate?.loadUserFinished()
                
                switch result {
                case .failure(let error):
                    if let delegate = self.delegate {
                        print("list users failed: \(error)")
                        delegate.showAlert(
                            msg: NSLocalizedString("alert.general.message", tableName: "RatingScreen", comment: "")
                        )
                    }
                case .success(let newUsers):
                    self.lastLoadedPage = nextPage
                    self.users.append(contentsOf: newUsers)
                    
                    self.updateTableViewAnimated(newUsers)
                }
            }
        }
     }
    
    func updateTableViewAnimated(_ newUsers: [User]) {
        if lastLoadedPage == 1 {
            delegate?.reloadData()
            return
        }
        
        let startIndex = users.count - newUsers.count
        let endIndex = startIndex + newUsers.count
        let indexPaths = (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
        
        delegate?.performBatchUpdates(indexPaths: indexPaths)
    }
    
    func setSortParameter(_ sortParameter: UsersSortParameter) {
        self.sortParameter = sortParameter
        
        lastLoadedPage = 0
        users = []
    }
    
    func setSortOrder(_ sortOrder: UsersSortOrder) {
        self.sortOrder = sortOrder
    }
}
