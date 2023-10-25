//
//  NFTsCollectionView.swift
//  FakeNFT
//
//  Created by Алия Давлетова on 19.10.2023.
//

import Foundation
import UIKit

final class NFTsCollectionView: UIViewController {
    private let cellReusableIdentifier = "reusableCell123"
    private let nftIDs: [String]
    
    private var presenter: NFTCollectionPresenterProtocol
    
    lazy private var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.backgroundColor = .ypWhite
        collection.translatesAutoresizingMaskIntoConstraints = false
        
        collection.dataSource = self
        collection.delegate = self
        
        collection.register(NFTCollectionCell.self, forCellWithReuseIdentifier: cellReusableIdentifier)
        
        return collection
    }()
    
    init(nfts: [String], presenter: NFTCollectionPresenterProtocol) {
        self.nftIDs = nfts
        self.presenter = presenter
        
        print(nftIDs)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        
        setupNavBar()
       
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])

        UIBlockingProgressHUD.show()
        
        presenter.loadData(nftIDs: nftIDs)
    }
    
    func setupNavBar() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "backButton")
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .ypBlack
        
        navigationController?.title = NSLocalizedString("nav.bar.title", tableName: "CollectionScreen", comment: "")
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.ypBlack as Any,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.bold),
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
        ] as [NSAttributedString.Key : Any]
        navigationItem.title =  NSLocalizedString("nav.bar.title", tableName: "CollectionScreen", comment: "")
    }
}

extension NFTsCollectionView: NFTCollectionPresenterDelegateProtocol {
    func showAlert(alert: AlertModel) {
    
    }
    
    func reloadData() {
        UIBlockingProgressHUD.dismiss()
        collectionView.reloadData()
     }
    
    func reloadCell(by indexPath: IndexPath) {
        collectionView.reloadItems(at: [indexPath])
    }
}

extension NFTsCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.nftViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReusableIdentifier, for: indexPath)
        
        guard let nftCell = cell as? NFTCollectionCell else {
            return UICollectionViewCell()
        }
        
        if indexPath.row >= presenter.nftViewModels.count {
            assertionFailure("configCell: indexPath.row >= nfts.count")
            return UICollectionViewCell()
        }
        
        nftCell.indexPath = indexPath
        nftCell.delegate = self
        nftCell.configure(nftVM: presenter.nftViewModels[indexPath.row])
        
        return nftCell
    }
}

extension NFTsCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - (16 + 16)
        let cellWidth =  availableWidth / 3
  
        return CGSize(width: cellWidth, height: cellWidth + 56 + 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 28
    }
}

extension NFTsCollectionView: NFTCollectionCellDelegate {
    func didTapLikeButton(isLike: Bool, indexPath: IndexPath) {
        presenter.likeNFT(isLike: isLike, indexPath: indexPath)
    }
}
