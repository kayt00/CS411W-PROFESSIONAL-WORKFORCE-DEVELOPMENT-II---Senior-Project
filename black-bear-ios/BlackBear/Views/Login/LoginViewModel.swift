//
//  LoginViewModel.swift
//  BlackBear
//
//  Created by Jeremy Fleshman on 2/7/21.
//

import Foundation
import Combine

final class LoginViewModel: ObservableObject {
    @Published var authDidSucceed = false
    var cancellables = Set<AnyCancellable>()
    var userService: UserService?
    var networkService: NetworkService?

    func setup(_ userService: UserService, _ networkService: NetworkService) {
        self.userService = userService
        self.networkService = networkService

    }

    func registerInitialAdmin(user: User) {
        networkService?.registerInitialAdmin(for: user)
            .sink(receiveCompletion: { completion in
                print(".sink() received the completion", String(describing: completion))
                switch completion {
                    case .finished:
                        break
                    case .failure(let anError):
                        print("received error: ", anError)
                }
            }, receiveValue: { someValue in
                print(".sink() received \(someValue)")
            })
            .store(in: &cancellables)
    }

    func checkInitialAdminExists() {
        networkService?.checkInitialAdminExists()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                print("checkInitialAdminExists completion", String(describing: completion))
                switch completion {
                    case .finished:
                        break
                    case .failure(let anError):
                        print("received error: ", anError)
                }
            }, receiveValue: { [weak self] in
                guard let self = self else { return }
                print("doesInitAdminExist:  \($0)")
                self.userService?.adminUserExists = $0
            })
            .store(in: &cancellables)
    }

    func login(username: String, password: String) {
        networkService?.login(username: username, password: password)
            .sink(receiveCompletion: { completion in
                print(".sink() received the completion", String(describing: completion))
                switch completion {
                    case .finished:
                        break
                    case .failure(let anError):
                        print("received error: ", anError)
                }
            }, receiveValue: { [weak self] token in
                guard let self = self else { return }

                print("Token: \(token)")
                self.userService?.user.token = token
                self.userService?.userIsLoggedIn = true
                self.authDidSucceed = true
            })
            .store(in: &cancellables)
    }
}
