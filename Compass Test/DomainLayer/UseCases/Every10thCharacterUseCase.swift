//
//  Every10thCharacterUseCase.swift
//  Compass Test
//
//  Created by Martin Crespi on 05/08/2024.
//

import Foundation
import Combine

class Every10thCharacterUseCase: Every10thCharacterUseCaseProtocol {
    private let repository: Every10thCharacterRepositoryProtocol
    
    /**
     Build this Use Case
     
     - Parameter repository: A valid `Every10thCharacterRepositoryProtocol` implementation to be used for fetching the required data
     */
    init(repository: Every10thCharacterRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() -> AnyPublisher<Every10thCharacterModel, DataLayerError> {
        return repository.fetchRawData()
            .map { dto in
                let characters = Array(dto.rawText.enumerated().compactMap { index, char in
                    (index + 1) % 10 == 0 ? char : nil
                })
                return Every10thCharacterModel(characters: characters)
            }
            .eraseToAnyPublisher()
    }
}
