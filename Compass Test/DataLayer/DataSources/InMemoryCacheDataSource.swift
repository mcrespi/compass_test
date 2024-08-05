//
//  InMemoryCacheDataSource.swift
//  Compass Test
//
//  Created by Martin Crespi on 05/08/2024.
//

import Foundation
import Combine

class InMemoryCacheDataSource: CacheDataSourceProtocol {
    private var cache = [String: Data]()
    
    func saveData<T: Encodable>(_ data: T, for key: String) -> AnyPublisher<Void, DataLayerError> {
        do {
            let encodedData = try JSONEncoder().encode(data)
            cache[key] = encodedData
            return Just(())
                .setFailureType(to: DataLayerError.self)
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: DataLayerError.cacheError(error))
                .eraseToAnyPublisher()
        }
    }
    
    func fetchData<T: Decodable>(for key: String, as type: T.Type) -> AnyPublisher<T, DataLayerError> {
        guard let cachedData = cache[key] else {
            return Fail(error: DataLayerError.cacheError(NSError(domain: "DataNotFound", code: -1, userInfo: nil)))
                .eraseToAnyPublisher()
        }
        
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: cachedData)
            return Just(decodedData)
                .setFailureType(to: DataLayerError.self)
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: DataLayerError.cacheError(error))
                .eraseToAnyPublisher()
        }
    }
}
