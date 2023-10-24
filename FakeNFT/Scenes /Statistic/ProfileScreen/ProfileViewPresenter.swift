//
//  ProfileViewPresenter.swift
//  FakeNFT
//
//  Created by Алия Давлетова on 18.10.2023.
//

import Foundation
import UIKit

protocol ProfileViewPresenterProtocol {
    func didTapProfileWebsite()
    func didTapNFTsCollection()
    func setImage()
}

protocol ProfileViewPresenterDelegateProtocol: AnyObject {
    var user: User { get }
    var avatarView: UIImageView { get set }
    
    func showAlert(alert: AlertModel)
    func showViewController(_ viewController: UIViewController)
    func closeWebView()
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    weak var delegate: ProfileViewPresenterDelegateProtocol?
    var webViewController: WebViewControllerInput?
    
    func didTapProfileWebsite() {
        guard
            let delegate = delegate,
            let url = URL(string: delegate.user.website)
        else {
            let alertModel = AlertModel(
                style: .alert,
                title: NSLocalizedString("alert.bad.url", tableName: "StatisticProfileScreen", comment: ""),
                actions: [
                    UIAlertAction(
                        title: NSLocalizedString("alert.bad.url.close", tableName: "StatisticProfileScreen", comment: ""),
                        style: .cancel
                    ) { _ in }
                ]
            )
            delegate?.showAlert(alert: alertModel)
            
            return
        }
        
        let webViewController = WebViewController(with: url, output: self)
        self.webViewController = webViewController
        
        delegate.showViewController(webViewController)
    }
    
    func didTapNFTsCollection() {
        let collectionPresenter = NFTCollectionPresenter(
            nftService: NFTService(networkClient: DefaultNetworkClient()),
            profileService: ProfileService(networkClient: DefaultNetworkClient())
        )
        let collectionVC = NFTsCollectionView(nfts: delegate?.user.nfts ?? [])
        
        collectionVC.presenter = collectionPresenter
        collectionPresenter.delegate = collectionVC
        
        delegate?.showViewController(collectionVC)
    }
    
    func setImage() {
        guard
            let delegate = delegate,
            let url = URL(string: delegate.user.avatarUrl)
        else {
            print("failed to get url")
            return
        }
        delegate.avatarView.kf.setImage(with: url, placeholder: unknownAvatar)
    }
}

extension ProfileViewPresenter: WebViewControllerOutput {
    func webViewDidLoad() {
        webViewController?.startLoading()
    }
    
    func didTapBackButton() {
        delegate?.closeWebView()
    }
}
