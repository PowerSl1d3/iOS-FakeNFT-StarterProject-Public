import Foundation

extension String {
    // TabBar
    enum TabBar {
        static let profile = NSLocalizedString("", value: "Профиль", comment: "")
        static let catalog = NSLocalizedString("", value: "Каталог", comment: "")
        static let cart = NSLocalizedString("", value: "Корзина", comment: "")
        static let statistics = NSLocalizedString("", value: "Статистика", comment: "")
    }

    // Profile
    enum ProfileTable {
        static let myNFTs = NSLocalizedString("", value: "Мои NFT ", comment: "")
        static let myLikes = NSLocalizedString("", value: "Избранные NFT ", comment: "")
        static let about = NSLocalizedString("", value: "О разработчике", comment: "")
    }

    enum ProfileEdit {
        static let name = NSLocalizedString("", value: "Имя", comment: "")
        static let description = NSLocalizedString("", value: "Описание", comment: "")
        static let website = NSLocalizedString("", value: "Сайт", comment: "")
        static let changePhoto = NSLocalizedString("", value: "Сменить фото", comment: "")
    }
}
