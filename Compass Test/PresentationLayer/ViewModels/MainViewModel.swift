//
//  Every10thCharacterViewModel.swift
//  Compass Test
//
//  Created by Martin Crespi on 05/08/2024.
//

import Foundation
import Combine

class MainViewModel: ObservableObject {
    @Published var every10thCharacterResult: String = ""
    @Published var wordCountResult: [String: Int] = [:]
    @Published var isFetching: Bool = false
    private var cancellables = Set<AnyCancellable>()
    
    private let every10thCharacterUseCase: Every10thCharacterUseCaseProtocol
    private let wordCountUseCase: WordCountUseCaseProtocol
    private let schedulerProvider: SchedulerProviderProtocol
    
    private var fetchCompletionCount = 0
    
    /**
     Build this ViewModel
     
     - Parameter every10thCharacterUseCase: A valid `Every10thCharacterUseCaseProtocol` implementation used for fetching every 10th character
     - Parameter wordCountUseCase: A valid `WordCountUseCaseProtocol` implementation used for fetching the word count
     - Parameter schedulerProvider: A valid `SchedulerProviderProtocol` implementation used to provide the schedulers for executing and observing publishers
     */
    init(every10thCharacterUseCase: Every10thCharacterUseCaseProtocol,
         wordCountUseCase: WordCountUseCaseProtocol,
         schedulerProvider: SchedulerProviderProtocol) {
        self.every10thCharacterUseCase = every10thCharacterUseCase
        self.wordCountUseCase = wordCountUseCase
        self.schedulerProvider = schedulerProvider
    }
    
    func fetchData() {
        guard !isFetching else { return }
        isFetching = true
        fetchCompletionCount = 0
        
        let every10thCharacterPublisher = every10thCharacterUseCase.execute()
            .subscribe(on: schedulerProvider.io())
            .map { $0.characters.map { String($0) }.joined(separator: ", ") }
            .receive(on: schedulerProvider.ui())
            .replaceError(with: "")
        
        let wordCountPublisher = wordCountUseCase.execute()
            .subscribe(on: schedulerProvider.io())
            .map { $0.wordCounts }
            .receive(on: schedulerProvider.ui())
            .replaceError(with: [:])
        
        every10thCharacterPublisher
            .sink { [weak self] result in
                self?.every10thCharacterResult = result
                self?.checkFetchCompletion()
            }
            .store(in: &cancellables)
        
        wordCountPublisher
            .sink { [weak self] result in
                self?.wordCountResult = result
                self?.checkFetchCompletion()
            }
            .store(in: &cancellables)
    }
    
    private func checkFetchCompletion() {
        fetchCompletionCount += 1
        if fetchCompletionCount == 2 {
            isFetching = false
        }
    }
}
