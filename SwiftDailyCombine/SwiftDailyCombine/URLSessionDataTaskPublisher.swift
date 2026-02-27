//
//  URLSessionDataTaskPublisher.swift
//  SwiftDailyCombine
//
//  Created by Javier Calatrava on 26/2/26.
//

import Foundation
import Combine

struct Post: Decodable {
    let id: Int
    let title: String
}

enum APIError: Error {
    case badStatus(Int)
}

final class PostsService {
    func fetchPosts() -> AnyPublisher<[Post], Error> {
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!

        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { output -> Data in
                if let http = output.response as? HTTPURLResponse,
                   !(200...299).contains(http.statusCode) {
                    throw APIError.badStatus(http.statusCode)
                }
                return output.data
            }
            .decode(type: [Post].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}


let service = PostsService()

func PostServiceUsage() {

    service.fetchPosts()
        .receive(on: DispatchQueue.main) // UI updates
        .sink(
            receiveCompletion: { print("Completion:", $0) },
            receiveValue: { posts in print("Posts:", posts.count) }
        )
        .store(in: &cancellables)
}
