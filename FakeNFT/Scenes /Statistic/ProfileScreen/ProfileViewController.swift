//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by Алия Давлетова on 16.10.2023.
//

import Foundation
import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    var user: User
    var presenter: ProfileViewPresenterProtocol
    
    lazy internal var avatarView: UIImageView = {
        let imageView = UIImageView(image: unknownAvatar)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .gray
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    lazy private var titleLabel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        title.textColor = .black
        title.numberOfLines = 2
        
        return title
    }()
    
    lazy private var descriptionLabel: UILabel = {
        let description = UILabel()
        description.textColor = .ypBlack
        description.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        description.translatesAutoresizingMaskIntoConstraints = false
        description.textAlignment = .left
        description.numberOfLines = 0
        
        return description
    }()
    
    lazy private var siteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(
            NSLocalizedString("go.to.user.site.button", tableName: "StatisticProfileScreen", comment: ""),
            for: .normal
        )
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        button.setTitleColor(UIColor.ypBlack, for: .normal)
        button.layer.borderColor = UIColor.ypBlack.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapProfileWebsite), for: .touchUpInside)
        
        return button
    }()
    
    lazy var nftcCllectionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = .ypBlack
        label.textAlignment = .left
        
        return label
    }()
    
    lazy private var collectionView: UIView = {
        let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 375, height: 54)))
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 8, height: 14))
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .ypBlack
        
        view.addSubview(nftcCllectionLabel)
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            nftcCllectionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nftcCllectionLabel.topAnchor.constraint(equalTo: view.topAnchor),
            nftcCllectionLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            imageView.heightAnchor.constraint(equalToConstant: 21),
            imageView.widthAnchor.constraint(equalToConstant: 12),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            nftcCllectionLabel.trailingAnchor.constraint(lessThanOrEqualTo: imageView.leadingAnchor),
        ])
        

        return view
    }()
    
    init(user: User, presenter: ProfileViewPresenter) {
        self.user = user
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "backButton")
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .ypBlack
        
        titleLabel.text = user.name
        descriptionLabel.text = user.description
        let nftCollection = NSLocalizedString("nft.collection", tableName: "StatisticProfileScreen", comment: "")
        nftcCllectionLabel.text = "\(nftCollection) (\(user.nfts.count))"
        
        view.addSubview(avatarView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(siteButton)
        view.addSubview(collectionView)
        
        setupConstraint()
        
        presenter.setImage()
    }
    
    func setupConstraint() {
        NSLayoutConstraint.activate([
            avatarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            avatarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            avatarView.heightAnchor.constraint(equalToConstant: 70),
            avatarView.widthAnchor.constraint(equalToConstant: 70),
            
            titleLabel.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            siteButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 28),
            siteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            siteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            siteButton.heightAnchor.constraint(equalToConstant: 40),
            
            collectionView.topAnchor.constraint(equalTo: siteButton.bottomAnchor, constant: 40),
            collectionView.heightAnchor.constraint(equalToConstant: 40),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    @objc func didTapProfileWebsite() {
        presenter.didTapProfileWebsite()
    }
}

extension ProfileViewController: ProfileViewPresenterDelegateProtocol {
    func showAlert(alert: AlertModel) {
        let alertPresenter = AlertPresenter(delegate: self)
        alertPresenter.show(result: alert)
    }
    
    func showWebView(_ webView: UIViewController) {
        navigationController?.pushViewController(webView, animated: true)
    }
    
    func closeWebView() {
        navigationController?.popViewController(animated: true)
    }
}
