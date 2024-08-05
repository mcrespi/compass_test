//
//  WordCountUseCase.swift
//  Compass Test
//
//  Created by Martin Crespi on 05/08/2024.
//

import Foundation
import Combine

class WordCountUseCase: WordCountUseCaseProtocol {
    private let repository: WordCountRepositoryProtocol

    /**
     Build this Use Case
     
     - Parameter repository: A valid `WordCountRepositoryProtocol` implementation to be used for fetching the required data
     */
    init(repository: WordCountRepositoryProtocol) {
        self.repository = repository
    }

    func execute() -> AnyPublisher<WordCountModel, DataLayerError> {
        return repository.fetchRawData()
            .map { dto in
                let words = dto.rawText
                    .lowercased()
                    .components(separatedBy: CharacterSet.whitespacesAndNewlines)
                    .filter { !$0.isEmpty }

                let wordCounts = words.reduce(into: [String: Int]()) { counts, word in
                    counts[word, default: 0] += 1
                }

                return WordCountModel(wordCounts: wordCounts)
            }
            .eraseToAnyPublisher()
    }
}
