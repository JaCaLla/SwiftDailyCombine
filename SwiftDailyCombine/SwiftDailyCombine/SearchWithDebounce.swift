//
//  SearchWithDebounce.swift
//  SwiftDailyCombine
//
//  Created by Javier Calatrava on 26/2/26.
//

import Combine
import UIKit

final class SearchViewModel {

    let query = PassthroughSubject<String, Never>()

    @Published private(set) var results: [String] = []

    private var cancellables = Set<AnyCancellable>()

    init() {
        query
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .removeDuplicates()
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .filter { !$0.isEmpty }
            .flatMap { q in
                Self.searchPublisher(query: q)
                    .catch { _ in Just([]) }
            }
            .assign(to: &$results)
    }

    private static func searchPublisher(query: String) -> AnyPublisher<[String], Error> {
        Future { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.2) {
                promise(.success(["\(query) 1", "\(query) 2", "\(query) 3"]))
            }
        }
        .eraseToAnyPublisher()
    }
}


final class SearchVC: UIViewController {
    private let vm = SearchViewModel()
    private var cancellables = Set<AnyCancellable>()
    private let textField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()

        textField.addTarget(self, action: #selector(textChanged), for: .editingChanged)

        vm.$results
            .receive(on: DispatchQueue.main)
            .sink { results in
                print("Resultados:", results)
            }
            .store(in: &cancellables)
    }

    @objc private func textChanged() {
        vm.query.send(textField.text ?? "")
    }
}
