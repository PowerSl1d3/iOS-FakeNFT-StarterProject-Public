//
//  UIBlockingProgressHUD.swift
//  FakeNFT
//
//  Created by Олег Аксененко on 10.10.2023.
//

import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
    private static var window: UIWindow? {
        UIApplication.shared.windows.first
    }

    static func show(with message: String? = nil) {
        window?.isUserInteractionEnabled = false
        ProgressHUD.show(message)
    }

    static func showError(_ errorMessage: String? = nil) {
        window?.isUserInteractionEnabled = false
        ProgressHUD.showError(errorMessage)

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            UIBlockingProgressHUD.dismiss()
        }
    }

    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}
