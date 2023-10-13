import Foundation

protocol ProfileServiceProtocol {
    func getProfile(
        with request: NetworkRequest,
        completion: @escaping (Result<Profile, Error>) -> Void
    )
}

final class ProfileService: ProfileServiceProtocol {
    private var task: URLSessionDataTask?
    private let networkClient: NetworkClient

    init(task: URLSessionDataTask? = nil, networkClient: NetworkClient = DefaultNetworkClient()) {
        self.task = task
        self.networkClient = networkClient
    }

    func getProfile(with request: NetworkRequest, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()

        let task = networkClient.send(
            request: request,
            type: Profile.self
        ) { [weak self] (result: Result<Profile, Error>) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let profile):
                    completion(.success(profile))
                case .failure(let error):
                    print(error)
                    completion(.failure(error))
                }
                self.task = nil
            }
        }

        self.task = task as? URLSessionDataTask
        self.task?.resume()
    }
}
