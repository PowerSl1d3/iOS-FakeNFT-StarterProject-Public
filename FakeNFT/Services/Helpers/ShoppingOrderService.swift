//
//  ShoppingOrderService.swift
//  FakeNFT
//
//  Created by Олег Аксененко on 21.10.2023.
//

import Foundation

protocol ShoppingOrderService {
    func loadShoppingOrder()
    func addToOrder(nftId: String, shoppingOrder: ShoppingOrder)
    func removeFromOrder(nftId: String, shoppingOrder: ShoppingOrder)
}

protocol ShoppingOrderServiceDelegate: AnyObject {
    func didLoadShoppingOrder(_ shoppingOrder: ShoppingOrder?)
    func didAddNFTFromOrder(_ newShoppingOrder: ShoppingOrder?)
    func didRemoveNFTFromOrder(_ newShoppingOrder: ShoppingOrder?)
}

final class ShoppingOrderServiceImpl {
    weak var delegate: ShoppingOrderServiceDelegate?
    let loader: ShoppingBagLoader = ShoppingBagLoaderImpl()
}

extension ShoppingOrderServiceImpl: ShoppingOrderService {
    func loadShoppingOrder() {
        loader.loadShoppingOrder(with: .name) { [weak self] shoppingOrder in
            self?.delegate?.didLoadShoppingOrder(shoppingOrder)
        }
    }

    func addToOrder(nftId: String, shoppingOrder: ShoppingOrder) {
        var newNFTSSet = Set(shoppingOrder.nfts)
        let (inserted, _) = newNFTSSet.insert(nftId)

        guard inserted else { return }

        let newNFTS = newNFTSSet.sorted { lhsNFTId, rhsNFTId in
            Int(lhsNFTId) ?? .zero < Int(rhsNFTId) ?? .zero
        }

        let newShoppingOrder = ShoppingOrder(
            nfts: newNFTS,
            id: shoppingOrder.id
        )

        loader.sendShoppingOrder(newShoppingOrder) { [weak self] updatedShoppingOrder in
            self?.delegate?.didAddNFTFromOrder(updatedShoppingOrder)
        }
    }

    func removeFromOrder(nftId: String, shoppingOrder: ShoppingOrder) {
        var newNFTSSet = Set(shoppingOrder.nfts)
        newNFTSSet.remove(nftId)

        let newNFTS = newNFTSSet.sorted { lhsNFTId, rhsNFTId in
            Int(lhsNFTId) ?? .zero < Int(rhsNFTId) ?? .zero
        }

        let newShoppingOrder = ShoppingOrder(
            nfts: newNFTS,
            id: shoppingOrder.id
        )

        loader.sendShoppingOrder(newShoppingOrder) { [weak self] updatedShoppingOrder in
            self?.delegate?.didRemoveNFTFromOrder(updatedShoppingOrder)
        }
    }
}
