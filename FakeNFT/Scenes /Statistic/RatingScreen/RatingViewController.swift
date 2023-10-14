//
//  RatingViewController.swift
//  FakeNFT
//
//  Created by Алия Давлетова on 09.10.2023.
//

import Foundation
import UIKit
import Kingfisher

let horizontalPadding: CGFloat = 16
let rowHeight: CGFloat = 88


protocol RatingViewPresenterProtocol: AnyObject {
    var users: [User] { get }
    
    func setDelegate(delegate: RatingViewPresenterDelegate)
    func listUsers()
    
    func setSortParameter(_ sortParameter: UsersSortParameter)
    func setSortOrder(_ sortOrder: UsersSortOrder)
}

final class RatingViewController: UIViewController {
    private let cellIdentifier = "cell"
    
    lazy private var presenter: RatingViewPresenterProtocol = {
        let defaultNetworkClient = DefaultNetworkClient()
        presenter = RatingViewPresenter(networkClient: defaultNetworkClient)
        presenter.setDelegate(delegate: self)
        return presenter
    }()
    
    lazy private var table: UITableView = {
        let table = UITableView()
        table.rowHeight = rowHeight
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .none
        table.backgroundColor = .background
        
        table.dataSource = self
        table.delegate = self
        
        table.register(RatingCell.self, forCellReuseIdentifier: cellIdentifier)
        
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        
        view.addSubview(table)
        
        setupConstraints()
        presenter.listUsers()
    }
    func setupNavBar() {
       let rightBarButtonItem = UIBarButtonItem(
           image: UIImage(named: "sortIcon"),
           style: .plain,
           target: self,
           action: #selector(didTapSortButton)
       )
       rightBarButtonItem.tintColor = .black

       navigationItem.setRightBarButton(rightBarButtonItem, animated: false)
   }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding),
            table.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

extension RatingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.users.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == presenter.users.count - 1 {
            presenter.listUsers()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = RatingCell()
        cell.selectionStyle = .none
        
        if indexPath.row >= presenter.users.count {
            assertionFailure("configCell: indexPath.row >= users.count")
            return cell
        }

        cell.configure(
            indexPath: indexPath,
            name: presenter.users[indexPath.row].name,
            avatarUrl: presenter.users[indexPath.row].avatarUrl,
            rating: presenter.users[indexPath.row].rating
        )

        return cell
    }
}

extension RatingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row >= presenter.users.count {
            assertionFailure("didSelectRowAt: indexPath.row >= users.count")
            return
        }
        
        let profileVC = ProfileViewController(user: presenter.users[indexPath.row])
        
        navigationController!.pushViewController(profileVC, animated: true)
    }
}

extension RatingViewController: RatingViewPresenterDelegate {
    func loadUserStarted() {
        UIBlockingProgressHUD.show()
    }
    
    func loadUserFinished() {
        UIBlockingProgressHUD.dismiss()
    }
    
    func showAlert(msg: String) {
        let alert = UIAlertController(
            title: NSLocalizedString("alert.title", tableName: "RatingScreen", comment: ""),
            message: msg,
            preferredStyle: .alert
        )
        
        let actionExit = UIAlertAction(
            title: NSLocalizedString("alert.close", tableName: "RatingScreen", comment: ""),
            style: .default
        ) { _ in }
        
        alert.addAction(actionExit)
        
        present(alert, animated: true)
    }
    
    func performBatchUpdates(indexPaths: [IndexPath]) {
        table.performBatchUpdates {
            self.table.insertRows(at: indexPaths, with: .automatic)
        }
    }
    
    func reloadData() {
        table.reloadData()
        if table.numberOfRows(inSection: 0) != 0 {
            table.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
}

extension RatingViewController {
    @objc func didTapSortButton() {
        let nameSort = UIAlertAction(
            title: NSLocalizedString("sort.byname", tableName: "RatingScreen", comment: ""),
            style: .destructive
        ) { [weak self] _ in
            guard let self = self else {
                assertionFailure("didTapSortButton: self is empty")
                return
            }

            self.presenter.setSortParameter(UsersSortParameter.byName)
            self.presenter.setSortOrder(UsersSortOrder.asc)
            
            self.presenter.listUsers()
        }
        
        let ratingSort = UIAlertAction(
            title: NSLocalizedString("sort.byrating", tableName: "RatingScreen", comment: ""),
            style: .destructive
        ) { [weak self] _ in
            guard let self = self else {
                assertionFailure("didTapSortButton: self is empty")
                return
            }

            self.presenter.setSortParameter(UsersSortParameter.byRating)
            self.presenter.setSortOrder(UsersSortOrder.asc)
            
            self.presenter.listUsers()
        }
        
        let cancel = UIAlertAction(
            title: NSLocalizedString("sort.close", tableName: "RatingScreen", comment: ""),
            style: .cancel
        )
        
        let alert = UIAlertController(
            title: NSLocalizedString("sort.title", tableName: "RatingScreen", comment: ""),
            message: "",
            preferredStyle: .actionSheet)
        
        alert.addAction(nameSort)
        alert.addAction(ratingSort)
        alert.addAction(cancel)
        
        self.present(alert, animated: true)
    }
}
