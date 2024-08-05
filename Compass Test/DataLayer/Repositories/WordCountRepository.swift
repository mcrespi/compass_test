//
//  WordCountRepository.swift
//  Compass Test
//
//  Created by Martin Crespi on 05/08/2024.
//

import Foundation
import Combine

class WordCountRepository: WordCountRepositoryProtocol {
    private let networkingDataSource: NetworkingDataSourceProtocol
    private let cacheDataSource: CacheDataSourceProtocol
    
    /**
     Build this Repository
     
     - Parameter networkingDataSource: A valid `NetworkingDataSourceProtocol` implementation to be used for networking operations
     - Parameter cacheDataSource: A valid `CacheDataSourceProtocol` implementation to be used for caching operations
     */
    init(networkingDataSource: NetworkingDataSourceProtocol,
         cacheDataSource: CacheDataSourceProtocol) {
        self.networkingDataSource = networkingDataSource
        self.cacheDataSource = cacheDataSource
    }
    
    func fetchRawData() -> AnyPublisher<WordCountDTO, DataLayerError> {
        let cacheKey = "wordCountRawData"
        
        return cacheDataSource.fetchData(for: cacheKey, as: WordCountDTO.self)
            .tryCatch { _ in
                return self.networkingDataSource.fetchData(from: "https://www.compass.com/about/")
                    .tryMap { data -> WordCountDTO in
                        guard let content = String(data: data, encoding: .utf8) else {
                            throw DataLayerError.networkError(URLError(.badServerResponse))
                        }
                        return WordCountDTO(rawText: content)
                    }
                    .flatMap { dto in
                        return self.cacheDataSource.saveData(dto, for: cacheKey)
                            .map { dto }
                            .mapError { error in
                                DataLayerError.cacheError(error)
                            }
                            .eraseToAnyPublisher()
                    }
                    .mapError { error in
                        DataLayerError.networkError(error)
                    }
                    .eraseToAnyPublisher()
            }
            .mapError { error in
                (error as? DataLayerError) ?? DataLayerError.unknownError(error)
            }
            .eraseToAnyPublisher()
    }
}
