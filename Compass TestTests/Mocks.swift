//
//  Mocks.swift
//  Compass TestTests
//
//  Created by Martin Crespi on 05/08/2024.
//

import Foundation
import Combine

@testable import Compass_Test

class MockNetworkingDataSource: NetworkingDataSourceProtocol {
    var spyFetchData_count: Int = 0
    var spyFetchData_endpoint: String?
    var spyFetchData_return: Result<Data, DataLayerError>?
    
    func fetchData(from endpoint: String) -> AnyPublisher<Data, DataLayerError> {
        spyFetchData_count += 1
        spyFetchData_endpoint = endpoint
        
        guard let result = spyFetchData_return else {
            return Fail(error: DataLayerError.networkError(URLError(.badURL)))
                .eraseToAnyPublisher()
        }
        
        return result.publisher.eraseToAnyPublisher()
    }
}

class MockCacheDataSource: CacheDataSourceProtocol {
    var spySaveData_count: Int = 0
    var spySaveData_data: Any?
    var spySaveData_key: String?
    var spySaveData_return: Result<Void, DataLayerError>?
    
    var spyFetchData_count: Int = 0
    var spyFetchData_key: String?
    var spyFetchData_type: Any.Type?
    var spyFetchData_return: Result<Any, DataLayerError>?
    
    func saveData<T>(_ data: T, for key: String) -> AnyPublisher<Void, DataLayerError> where T : Encodable {
        spySaveData_count += 1
        spySaveData_data = data
        spySaveData_key = key
        
        guard let saveResult = spySaveData_return else {
            return Fail(error: DataLayerError.cacheError(NSError()))
                .eraseToAnyPublisher()
        }
        
        return saveResult.publisher.eraseToAnyPublisher()
    }
    
    func fetchData<T>(for key: String, as type: T.Type) -> AnyPublisher<T, DataLayerError> where T : Decodable {
        spyFetchData_count += 1
        spyFetchData_key = key
        spyFetchData_type = type
        
        guard let fetchResult = spyFetchData_return else {
            return Fail(error: DataLayerError.cacheError(NSError()))
                .eraseToAnyPublisher()
        }
        
        return fetchResult.publisher
            .compactMap { $0 as? T }
            .eraseToAnyPublisher()
    }
}

class MockEvery10thCharacterRepository: Every10thCharacterRepositoryProtocol {
    var spyFetchRawData_count: Int = 0
    var spyFetchRawData_return: Result<Every10thCharacterDTO, DataLayerError>?
    
    func fetchRawData() -> AnyPublisher<Every10thCharacterDTO, DataLayerError> {
        spyFetchRawData_count += 1
        
        guard let result = spyFetchRawData_return else {
            return Fail(error: DataLayerError.unknownError(NSError()))
                .eraseToAnyPublisher()
        }
        
        return result.publisher.eraseToAnyPublisher()
    }
}

class MockWordCountRepository: WordCountRepositoryProtocol {
    var spyFetchRawData_count: Int = 0
    var spyFetchRawData_return: Result<WordCountDTO, DataLayerError>?
    
    func fetchRawData() -> AnyPublisher<WordCountDTO, DataLayerError> {
        spyFetchRawData_count += 1
        
        guard let result = spyFetchRawData_return else {
            return Fail(error: DataLayerError.unknownError(NSError()))
                .eraseToAnyPublisher()
        }
        
        return result.publisher.eraseToAnyPublisher()
    }
}

class MockSchedulerProvider: SchedulerProviderProtocol {
    var spyIO_count: Int = 0
    var spyUI_count: Int = 0
    
    let ioScheduler: DispatchQueue = DispatchQueue(label: "io")
    let uiScheduler: DispatchQueue = DispatchQueue.main
    
    func io() -> DispatchQueue {
        spyIO_count += 1
        
        return ioScheduler
    }
    
    func ui() -> DispatchQueue {
        spyUI_count += 1
        
        return uiScheduler
    }
}

class MockEvery10thCharacterUseCase: Every10thCharacterUseCaseProtocol {
    var spyExecute_count: Int = 0
    var spyExecute_return: Result<Every10thCharacterModel, DataLayerError>?
    
    func execute() -> AnyPublisher<Every10thCharacterModel, DataLayerError> {
        spyExecute_count += 1
        
        guard let result = spyExecute_return else {
            return Fail(error: DataLayerError.unknownError(NSError()))
                .eraseToAnyPublisher()
        }
        
        return result.publisher.eraseToAnyPublisher()
    }
}

class MockWordCountUseCase: WordCountUseCaseProtocol {
    var spyExecute_count: Int = 0
    var spyExecute_return: Result<WordCountModel, DataLayerError>?
    
    func execute() -> AnyPublisher<WordCountModel, DataLayerError> {
        spyExecute_count += 1
        
        guard let result = spyExecute_return else {
            return Fail(error: DataLayerError.unknownError(NSError()))
                .eraseToAnyPublisher()
        }
        
        return result.publisher.eraseToAnyPublisher()
    }
}
