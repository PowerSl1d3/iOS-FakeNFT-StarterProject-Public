import Foundation

protocol ProfileEditViewModelProtocol {
    func setProfileEdited(_ value: ProfileEdited)
    var profileEdited: ProfileEdited { get }
    var profile: Profile { get }
    var profileObservable: Observable<Profile> { get }
}

final class ProfileEditViewModel: ProfileEditViewModelProtocol {
    private let profileService: ProfileServiceProtocol

    private(set) var profileEdited: ProfileEdited

    @Observable
    private(set) var profile: Profile
    var profileObservable: Observable<Profile> { $profile }

    init(_ profileEdited: ProfileEdited, profile: Profile = Profile(), profileService: ProfileServiceProtocol = ProfileService()) {
        self.profileService = profileService
        self.profile = profile
        self.profileEdited = profileEdited
    }

    private func changeProfile() {
        let request = ProfilePutRequest(profileEdited)

        profileService.getProfile(with: request) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                self.profile = profile
            case .failure:
                self.changeProfile()
            }
        }
    }

    func setProfileEdited(_ value: ProfileEdited) {
        profileEdited = value
        changeProfile()
    }
}
