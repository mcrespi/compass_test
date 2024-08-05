//
//  NetworkingDataSource.swift
//  Compass Test
//
//  Created by Martin Crespi on 05/08/2024.
//

import Foundation
import Combine

class NetworkingDataSource: NetworkingDataSourceProtocol {
    func fetchData(from endpoint: String) -> AnyPublisher<Data, DataLayerError> {
        guard let url = URL(string: endpoint) else {
            return Fail(error: DataLayerError.networkError(URLError(.badURL))).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .mapError { DataLayerError.networkError($0) }
            .eraseToAnyPublisher()
    }
}
