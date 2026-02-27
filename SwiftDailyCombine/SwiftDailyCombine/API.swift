//
//  API.swift
//  SwiftDailyCombine
//
//  Created by Javier Calatrava on 25/2/26.
//
import Foundation

struct User: Decodable {
    let id: Int
    let name: String
}

final class API {
    func fetchUser(id: Int, completion: @escaping (Result<User, Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.3) {
            completion(.success(User(id: id, name: "Ada")))
        }
    }
}
