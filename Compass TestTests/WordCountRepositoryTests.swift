//
//  WordCountRepositoryTests.swift
//  Compass TestTests
//
//  Created by Martin Crespi on 05/08/2024.
//

import XCTest
import Combine

@testable import Compass_Test

class WordCountRepositoryTests: XCTestCase {
    var mockNetworkingDataSource: MockNetworkingDataSource!
    var mockCacheDataSource: MockCacheDataSource!
    var cancellables: Set<AnyCancellable>!
    
    var repository: WordCountRepository!
    
    override func setUp() {
        super.setUp()
        mockNetworkingDataSource = MockNetworkingDataSource()
        mockCacheDataSource = MockCacheDataSource()
        
        repository = WordCountRepository(
            networkingDataSource: mockNetworkingDataSource,
            cacheDataSource: mockCacheDataSource
        )
        
        cancellables = []
    }
    
    func testFetchDataFromCacheSuccess() {
        let cachedDTO = WordCountDTO(rawText: "cached data")
        mockCacheDataSource.spyFetchData_return = .success(cachedDTO)
        
        let expectation = XCTestExpectation(description: "Fetch data from cache")
        
        repository.fetchRawData()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Expected success but got error: \(error)")
                }
            }, receiveValue: { dto in
                XCTAssertEqual(self.mockCacheDataSource.spyFetchData_count, 1)
                XCTAssertEqual(self.mockCacheDataSource.spySaveData_count, 0)
                XCTAssertEqual(self.mockNetworkingDataSource.spyFetchData_count, 0)
                XCTAssertEqual(self.mockCacheDataSource.spyFetchData_key, "wordCountRawData")
                XCTAssertTrue(self.mockCacheDataSource.spyFetchData_type == WordCountDTO.self)
                
                XCTAssertEqual(dto.rawText, "cached data")
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchDataFromNetworkSuccess() {
        let networkText = "network data"
        let networkData = networkText.data(using: .utf8)!
        
        mockCacheDataSource.spyFetchData_return = .failure(DataLayerError.cacheError(NSError(domain: "DataNotFound", code: -1, userInfo: nil)))
        mockNetworkingDataSource.spyFetchData_return = .success(networkData)
        mockCacheDataSource.spySaveData_return = .success(())
        
        let expectation = XCTestExpectation(description: "Fetch data from network")
        
        repository.fetchRawData()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Expected success but got error: \(error)")
                }
            }, receiveValue: { dto in
                XCTAssertEqual(self.mockCacheDataSource.spyFetchData_count, 1)
                XCTAssertEqual(self.mockCacheDataSource.spySaveData_count, 1)
                XCTAssertEqual(self.mockNetworkingDataSource.spyFetchData_count, 1)
                
                XCTAssertEqual(self.mockCacheDataSource.spyFetchData_key, "wordCountRawData")
                XCTAssertTrue(self.mockCacheDataSource.spyFetchData_type == WordCountDTO.self)
                
                XCTAssertEqual(self.mockCacheDataSource.spySaveData_key, "wordCountRawData")
                XCTAssertTrue((self.mockCacheDataSource.spySaveData_data as? WordCountDTO)?.rawText == String(data: networkData, encoding: .utf8))
                
                XCTAssertEqual(dto.rawText, networkText)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchDataFromNetworkFailure() {
        mockCacheDataSource.spyFetchData_return = .failure(DataLayerError.cacheError(NSError(domain: "DataNotFound", code: -1, userInfo: nil)))
        mockNetworkingDataSource.spyFetchData_return = .failure(DataLayerError.networkError(URLError(.notConnectedToInternet)))

        let expectation = XCTestExpectation(description: "Fetch data from network failure")

        repository.fetchRawData()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    switch error {
                    case .networkError(_):
                        XCTAssertEqual(self.mockCacheDataSource.spySaveData_count, 0)
                        XCTAssertEqual(self.mockCacheDataSource.spyFetchData_count, 1)
                        XCTAssertEqual(self.mockNetworkingDataSource.spyFetchData_count, 1)
                        XCTAssertEqual(self.mockNetworkingDataSource.spyFetchData_endpoint, "https://www.compass.com/about/")
                        
                        expectation.fulfill()
                    default:
                        XCTFail("Expected NetworkError but got \(error)")
                    }
                } else {
                    XCTFail("Expected failure but got \(completion)")
                }
            }, receiveValue: { _ in
                XCTFail("Expected no value but got some data")
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchDataFromCacheAndNetworkFailure() {
        mockCacheDataSource.spyFetchData_return = .failure(DataLayerError.cacheError(NSError()))
        mockNetworkingDataSource.spyFetchData_return = .failure(DataLayerError.networkError(URLError(.notConnectedToInternet)))
        
        let expectation = XCTestExpectation(description: "Fetch data from cache and network failure")

        repository.fetchRawData()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    switch error {
                    case .networkError(_):
                        XCTAssertEqual(self.mockCacheDataSource.spySaveData_count, 0)
                        XCTAssertEqual(self.mockCacheDataSource.spyFetchData_count, 1)
                        XCTAssertEqual(self.mockNetworkingDataSource.spyFetchData_count, 1)
                        XCTAssertEqual(self.mockNetworkingDataSource.spyFetchData_endpoint, "https://www.compass.com/about/")
                        
                        expectation.fulfill()
                    default:
                        XCTFail("Expected CacheError but got \(error)")
                    }
                }
            }, receiveValue: { _ in
                XCTFail("Expected no value but got some data")
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }
}
