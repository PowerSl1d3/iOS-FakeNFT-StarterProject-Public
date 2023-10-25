//
//  NFTCollectionCell.swift
//  FakeNFT
//
//  Created by Алия Давлетова on 20.10.2023.
//

import Foundation
import UIKit

protocol NFTCollectionCellDelegate {
    func didTapLikeButton(isLike: Bool, indexPath: IndexPath)
}

final class NFTCollectionCell: UICollectionViewCell {
    var delegate: NFTCollectionCellDelegate?
    var indexPath: IndexPath?
    
    private var isLike: Bool = false
    
    lazy private var likeButton: UIButton = {
        let like = UIButton()
        //  TODO: добавлять картинку в зависимости от FavoriteNFTService
        like.setImage(unlikeImage, for: .normal)
        like.translatesAutoresizingMaskIntoConstraints = false
        like.addTarget(self, action: #selector(didTapLkeButton), for: .touchUpInside)

        return like
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: imagePlaceholder)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        
        return imageView
    }()

    private lazy var starsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "star0"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapStars), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = .ypBlack
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        label.textColor = .ypBlack
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var basketIcon: UIImageView = {
        //TODO: сделать в соответствии с состоянием корзины
        let imageView = UIImageView(image: UIImage(named: "basket"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        imageView.addSubview(likeButton)
        imageView.isUserInteractionEnabled = true
        contentView.addSubview(starsButton)
        contentView.addSubview(basketIcon)
        
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        contentView.addSubview(stack)
        
        contentView.clipsToBounds = true
       
        stack.addSubview(nameLabel)
        stack.addSubview(priceLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: contentView.frame.width),

            likeButton.heightAnchor.constraint(equalToConstant: 40),
            likeButton.widthAnchor.constraint(equalToConstant: 40),
            likeButton.topAnchor.constraint(equalTo: imageView.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            
            starsButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            starsButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            starsButton.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor),
            starsButton.heightAnchor.constraint(equalToConstant: 12),
            
            stack.topAnchor.constraint(equalTo: starsButton.bottomAnchor, constant: 8),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            
            nameLabel.topAnchor.constraint(equalTo: stack.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: stack.trailingAnchor),
            
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: stack.trailingAnchor),
            
            basketIcon.centerYAnchor.constraint(equalTo: stack.centerYAnchor),
            basketIcon.leadingAnchor.constraint(equalTo: stack.trailingAnchor),
            basketIcon.widthAnchor.constraint(equalToConstant: 40),
            basketIcon.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(nftVM: NFTViewModel) {
        isLike = nftVM.isLike
        
        starsButton.setImage(UIImage(named: "star" + (nftVM.nft.rating.description)), for: .normal)
        nameLabel.text = nftVM.nft.name
        priceLabel.text = (nftVM.nft.price.description) + " ETH"
        
        likeButton.setImage(isLike ? likeImage : unlikeImage, for: .normal)
 
        guard
            let urlString = nftVM.nft.images.first,
            let url = URL(string: urlString)
        else {
            print("failed to load image from \(nftVM.nft.images)")
            return
        }
        
        imageView.kf.setImage(with: url, placeholder: imagePlaceholder)
    }
    
    @objc private func didTapLkeButton() {
        guard let indexPath = indexPath else {
            assertionFailure("didTapLkeButton: indexPath is empty")
            return
        }
        
        self.isLike = !isLike
        delegate?.didTapLikeButton(isLike: self.isLike, indexPath: indexPath)
    }
    
    @objc private func didTapStars() {
        print("!!!!!!!! didTapStars !!!!!!!!!!!")
    }
}
