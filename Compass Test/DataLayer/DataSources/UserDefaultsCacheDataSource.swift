//
//  UserDefaultsCacheDataSource.swift
//  Compass Test
//
//  Created by Martin Crespi on 05/08/2024.
//

import Foundation
import Combine

class UserDefaultsCacheDataSource: CacheDataSourceProtocol {
    func saveData<T: Encodable>(_ data: T, for key: String) -> AnyPublisher<Void, DataLayerError> {
        do {
            let encodedData = try JSONEncoder().encode(data)
            UserDefaults.standard.set(encodedData, forKey: key)
            return Just(()).setFailureType(to: DataLayerError.self).eraseToAnyPublisher()
        } catch {
            return Fail(error: DataLayerError.cacheError(error)).eraseToAnyPublisher()
        }
    }
    
    func fetchData<T: Decodable>(for key: String, as type: T.Type) -> AnyPublisher<T, DataLayerError> {
        guard let cachedData = UserDefaults.standard.data(forKey: key) else {
            return Fail(error: DataLayerError.cacheError(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Data not found in cache"]))).eraseToAnyPublisher()
        }
        
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: cachedData)
            return Just(decodedData).setFailureType(to: DataLayerError.self).eraseToAnyPublisher()
        } catch {
            return Fail(error: DataLayerError.decodingError(error)).eraseToAnyPublisher()
        }
    }
}
