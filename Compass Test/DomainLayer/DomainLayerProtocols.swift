//
//  DomainLayerProtocols.swift
//  Compass Test
//
//  Created by Martin Crespi on 05/08/2024.
//

import Foundation
import Combine

protocol Every10thCharacterUseCaseProtocol {
    /**
     Executes the use case to fetch and process Every 10th Character from the data source
     
     - Returns: A valid `Publisher` emitting an `Every10thCharacterModel` or a `DataLayerError`
     */
    func execute() -> AnyPublisher<Every10thCharacterModel, DataLayerError>
}

protocol WordCountUseCaseProtocol {
    /**
     Executes the use case to fetch and count the occurrences of each word from the data source
     
     - Returns: A valid `Publisher` emitting a `WordCountModel` or a `DataLayerError`
     */
    func execute() -> AnyPublisher<WordCountModel, DataLayerError>
}
