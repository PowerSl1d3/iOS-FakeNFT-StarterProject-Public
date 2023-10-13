import Foundation

protocol ProfileViewModelProtocol {
    func fetchProfile()
    var profileObservable: Observable<Profile> { get }
    var profile: Profile { get }
}

final class ProfileViewModel: ProfileViewModelProtocol {
    private let profileService: ProfileServiceProtocol

    @Observable
    private(set) var profile: Profile
    var profileObservable: Observable<Profile> { $profile }

    init(profileService: ProfileServiceProtocol = ProfileService(), profile: Profile = Profile()) {
        self.profileService = profileService
        self.profile = profile
    }

    func fetchProfile() {
        let request = ProfileGetRequest()
        profileService.getProfile(with: request) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                self.profile = profile
            case .failure:
                self.fetchProfile()
            }
        }
    }
}
