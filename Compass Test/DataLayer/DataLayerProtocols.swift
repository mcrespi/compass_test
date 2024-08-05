//
//  DataLayerProtocols.swift
//  Compass Test
//
//  Created by Martin Crespi on 05/08/2024.
//

import Foundation
import Combine

protocol NetworkingDataSourceProtocol {
    /**
     Fetches data from the given endpoint
     
     - Parameter endpoint: A valid `String` representing the endpoint from which to fetch data
     - Returns: A valid `Publisher` emitting the fetched data or an error
     */
    func fetchData(from endpoint: String) -> AnyPublisher<Data, DataLayerError>
}

protocol CacheDataSourceProtocol {
    /**
     Saves data to the cache
     
     - Parameter data: A valid `Encodable` representing the data to save
     - Parameter key: A valid `String` representing the key under which to save the data
     - Returns: A valid `Publisher` emitting completion or an error
     */
    func saveData<T: Encodable>(_ data: T, for key: String) -> AnyPublisher<Void, DataLayerError>
    
    /**
     Fetches data from the cache
     
     - Parameter key: A valid `String` representing the key under which the data is saved
     - Parameter type: A valid `Decodable` representing the data type to fetch
     */
    func fetchData<T: Decodable>(for key: String, as type: T.Type) -> AnyPublisher<T, DataLayerError>
}

protocol Every10thCharacterRepositoryProtocol {
    /**
     Fetches raw data for the Every 10th Character use case
     
     - Returns: A valid `Publisher` emitting the fetched data or an error
     */
    func fetchRawData() -> AnyPublisher<Every10thCharacterDTO, DataLayerError>
}

protocol WordCountRepositoryProtocol {
    /**
     Fetches raw data for the Word Count use case
     
     - Returns: A valid `Publisher` emitting the fetched data or an error
     */
    func fetchRawData() -> AnyPublisher<WordCountDTO, DataLayerError>
}
