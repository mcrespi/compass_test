//
//  Every10thCharacterUseCaseTests.swift
//  Compass TestTests
//
//  Created by Martin Crespi on 05/08/2024.
//

import XCTest
import Combine

@testable import Compass_Test

class Every10thCharacterUseCaseTests: XCTestCase {
    var useCase: Every10thCharacterUseCase!
    var mockRepository: MockEvery10thCharacterRepository!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockEvery10thCharacterRepository()
        useCase = Every10thCharacterUseCase(repository: mockRepository)
        cancellables = []
    }
    
    override func tearDown() {
        cancellables = nil
        useCase = nil
        mockRepository = nil
        super.tearDown()
    }
    
    func testExecuteSuccess() {
        let rawText = "This is a test string for every 10th character usecase."
        let dto = Every10thCharacterDTO(rawText: rawText)
        
        mockRepository.spyFetchRawData_return = .success(dto)
        
        let expectation = XCTestExpectation(description: "Fetch every 10th character success")
        
        useCase.execute()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Expected success but got error: \(error)")
                }
            }, receiveValue: { model in
                XCTAssertEqual(self.mockRepository.spyFetchRawData_count, 1)
                
                XCTAssertEqual(model.characters, [" ", "n", "r", "a", "e"])
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testExecuteFailure() {
        mockRepository.spyFetchRawData_return = .failure(DataLayerError.networkError(URLError(.notConnectedToInternet)))
        
        let expectation = XCTestExpectation(description: "Fetch every 10th character failure")
        
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
