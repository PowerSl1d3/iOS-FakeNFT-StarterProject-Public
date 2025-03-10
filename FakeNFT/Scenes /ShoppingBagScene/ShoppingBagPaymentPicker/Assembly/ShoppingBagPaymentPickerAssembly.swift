//
//  ShoppingBagPaymentPickerAssembly.swift
//  FakeNFT
//
//  Created by Олег Аксененко on 13.10.2023.
//

import UIKit

final class ShoppingBagPaymentPickerAssembly {
    private init() {}

    static func assemble(moduleOutput: ShoppingBagPaymentPickerModuleOutput? = nil) -> UIViewController {
        let interactor = ShoppingBagPaymentPickerInteractorImpl()
        let router = ShoppingBagPaymentPickerRouterImpl()
        let dataSource = ShoppingBagPaymentPickerDataSource()
        let stateStorage = ShoppingBagPaymentPickerStateStorage()
        let presenter = ShoppingBagPaymentPickerPresenter()

        let viewController = ShoppingBagPaymentPickerViewController()
        viewController.output = presenter
        viewController.setDataSource(dataSource)

        interactor.output = presenter
        dataSource.module = presenter
        router.viewController = viewController
        presenter.moduleOutput = moduleOutput
        presenter.view = viewController
        presenter.interactor = interactor
        presenter.router = router
        presenter.dataSource = dataSource
        presenter.stateStorage = stateStorage

        return viewController
    }
}
