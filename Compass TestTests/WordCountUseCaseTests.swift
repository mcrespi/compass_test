//
//  WordCountUseCaseTests.swift
//  Compass TestTests
//
//  Created by Martin Crespi on 05/08/2024.
//

import XCTest
import Combine

@testable import Compass_Test

class WordCountUseCaseTests: XCTestCase {
    var useCase: WordCountUseCase!
    var mockRepository: MockWordCountRepository!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockWordCountRepository()
        useCase = WordCountUseCase(repository: mockRepository)
        cancellables = []
    }
    
    override func tearDown() {
        cancellables = nil
        useCase = nil
        mockRepository = nil
        super.tearDown()
    }
    
    func testExecuteSuccess() {
        let rawText = "This is a test. This test is simple."
        let dto = WordCountDTO(rawText: rawText)
        
        mockRepository.spyFetchRawData_return = .success(dto)
        
        let expectation = XCTestExpectation(description: "Fetch word count success")
        
        useCase.execute()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Expected success but got error: \(error)")
                }
            }, receiveValue: { model in
                XCTAssertEqual(self.mockRepository.spyFetchRawData_count, 1)
                
                XCTAssertEqual(model.wordCounts, ["this": 2, "is": 2, "a": 1, "test.": 1, "test": 1, "simple.": 1])
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testExecuteFailure() {
        mockRepository.spyFetchRawData_return = .failure(DataLayerError.networkError(URLError(.notConnectedToInternet)))
        
        let expectation = XCTestExpectation(description: "Fetch word count failure")
        
        useCase.execute()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    switch error {
                    case .networkError:
                        XCTAssertEqual(self.mockRepository.spyFetchRawData_count, 1)
                        
                        expectation.fulfill()
                    default:
                        XCTFail("Expected NetworkError but got \(error)")
                    }
                } else {
                    XCTFail("Expected failure but got success")
                }
            }, receiveValue: { _ in
                XCTFail("Expected no value but got some data")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
}
