//
//  NFTsCollectionView.swift
//  FakeNFT
//
//  Created by Алия Давлетова on 19.10.2023.
//

import Foundation
import UIKit

final class NFTsCollectionView: UIViewController {
    private let nfts: [String]
    
    lazy private var nftsCollection: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collection.backgroundColor = .ypWhite
        collection.translatesAutoresizingMaskIntoConstraints = true
        collection.dataSource = self
        
        return collection
    }()
    
    init(nfts: [String]) {
        self.nfts = nfts
        self.nftsCollection = nftsCollection
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        
        view.addSubview(nftsCollection)
        
        NSLayoutConstraint.activate([
            nftsCollection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            nftsCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nftsCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nftsCollection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func setupNavBar() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "backButton")
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .ypBlack
        navigationController?.title = NSLocalizedString("nav.bar.title", tableName: "CollectionScreen", comment: "")
    }
}

extension NFTsCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        nfts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
    
    
}
