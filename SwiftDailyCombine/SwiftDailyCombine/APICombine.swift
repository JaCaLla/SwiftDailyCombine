//
//  APICombine.swift
//  SwiftDailyCombine
//
//  Created by Javier Calatrava on 25/2/26.
//

import Combine

final class APICombine {
    private let api = API()

    func fetchUser(id: Int) -> AnyPublisher<User, Error> {
        Future { [api] promise in
            api.fetchUser(id: id) { result in
                promise(result)
            }
        }
        .eraseToAnyPublisher()
    }
}

var cancellables = Set<AnyCancellable>()

func fetchUser(id: Int) {
    let api = APICombine()
    api.fetchUser(id: 1)
        .sink(
            receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Error:", error)
                }
            },
            receiveValue: { user in
                print("User:", user.name)
            }
        )
        .store(in: &cancellables)
}
