//
//  MainViewModelTests.swift
//  Compass TestTests
//
//  Created by Martin Crespi on 05/08/2024.
//

import XCTest
import Combine

@testable import Compass_Test

class MainViewModelTests: XCTestCase {
    var viewModel: MainViewModel!
    var mockEvery10thCharacterUseCase: MockEvery10thCharacterUseCase!
    var mockWordCountUseCase: MockWordCountUseCase!
    var mockSchedulerProvider: MockSchedulerProvider!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockEvery10thCharacterUseCase = MockEvery10thCharacterUseCase()
        mockWordCountUseCase = MockWordCountUseCase()
        mockSchedulerProvider = MockSchedulerProvider()
        viewModel = MainViewModel(every10thCharacterUseCase: mockEvery10thCharacterUseCase, wordCountUseCase: mockWordCountUseCase, schedulerProvider: mockSchedulerProvider)
        cancellables = []
    }
    
    override func tearDown() {
        cancellables = nil
        viewModel = nil
        mockEvery10thCharacterUseCase = nil
        mockWordCountUseCase = nil
        mockSchedulerProvider = nil
        super.tearDown()
    }
    
    func testFetchDataSuccess() {
        let every10thCharacterModel = Every10thCharacterModel(characters: ["a", "b", "c"])
        mockEvery10thCharacterUseCase.spyExecute_return = .success(every10thCharacterModel)
        
        let wordCountModel = WordCountModel(wordCounts: ["test": 1, "data": 2])
        mockWordCountUseCase.spyExecute_return = .success(wordCountModel)
        
        let expectation = XCTestExpectation(description: "Fetch data success")
        
        viewModel.$every10thCharacterResult
            .dropFirst()
            .sink { result in
                XCTAssertEqual(result, "a, b, c")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.$wordCountResult
            .dropFirst()
            .sink { result in
                XCTAssertEqual(result, ["test": 1, "data": 2])
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.fetchData()
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchDataFailure() {
        mockEvery10thCharacterUseCase.spyExecute_return = .failure(DataLayerError.networkError(URLError(.notConnectedToInternet)))
        mockWordCountUseCase.spyExecute_return = .failure(DataLayerError.networkError(URLError(.notConnectedToInternet)))
        
        let expectation = XCTestExpectation(description: "Fetch data failure")
        
        viewModel.$every10thCharacterResult
            .dropFirst()
            .sink { result in
                XCTAssertEqual(result, "")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.$wordCountResult
            .dropFirst()
            .sink { result in
                XCTAssertEqual(result, [:])
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.fetchData()
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testIsFetchingState() {
        let every10thCharacterModel = Every10thCharacterModel(characters: ["a", "b", "c"])
        mockEvery10thCharacterUseCase.spyExecute_return = .success(every10thCharacterModel)
        
        let wordCountModel = WordCountModel(wordCounts: ["test": 1, "data": 2])
        mockWordCountUseCase.spyExecute_return = .success(wordCountModel)
        
        let expectation = XCTestExpectation(description: "Fetch data isFetching state")
        
        var isFetchingStates = [Bool]()
        
        XCTAssertFalse(viewModel.isFetching)
            
        viewModel.$isFetching
            .dropFirst()
            .sink { isFetching in
                isFetchingStates.append(isFetching)
                if !isFetching {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.fetchData()
        
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertEqual(isFetchingStates, [true, false])
        
        XCTAssertEqual(mockEvery10thCharacterUseCase.spyExecute_count, 1)
        XCTAssertEqual(mockWordCountUseCase.spyExecute_count, 1)
    }
}
