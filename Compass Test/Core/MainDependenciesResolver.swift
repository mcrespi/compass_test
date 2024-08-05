//
//  MainDependenciesResolver.swift
//  Compass Test
//
//  Created by Martin Crespi on 05/08/2024.
//

import Foundation

class MainDependenciesResolver: DependenciesResolverProtocol {
    public static let shared = MainDependenciesResolver()
    
    private var networkingDataSource: NetworkingDataSourceProtocol?
    private var cacheDataSource: CacheDataSourceProtocol?
    private var schedulerProvider: SchedulerProviderProtocol?
    
    private init() {}
    
    func resolveViewModel() -> MainViewModel {
        return MainViewModel(every10thCharacterUseCase: resolveEvery10thCharacterUseCase(),
                             wordCountUseCase: resolveWordCountUseCase(),
                             schedulerProvider: resolveSchedulerProvider())
    }
    
    private func resolveEvery10thCharacterUseCase() -> Every10thCharacterUseCaseProtocol {
        return Every10thCharacterUseCase(repository: resolveEvery10thCharacterRepository())
    }
    
    private func resolveEvery10thCharacterRepository() -> Every10thCharacterRepositoryProtocol {
        return Every10thCharacterRepository(networkingDataSource: resolveNetworkingDataSource(),
                                            cacheDataSource: resolveCacheDataSource())
    }
    
    private func resolveNetworkingDataSource() -> NetworkingDataSourceProtocol {
        networkingDataSource = networkingDataSource ?? NetworkingDataSource()
        
        return networkingDataSource!
    }
    
    private func resolveCacheDataSource() -> CacheDataSourceProtocol {
        cacheDataSource = cacheDataSource ?? InMemoryCacheDataSource()
        
        return cacheDataSource!
    }
    
    private func resolveWordCountUseCase() -> WordCountUseCaseProtocol {
        return WordCountUseCase(repository: resolveWordCountRepository())
    }
    
    private func resolveWordCountRepository() -> WordCountRepositoryProtocol {
        return WordCountRepository(networkingDataSource: resolveNetworkingDataSource(),
                                   cacheDataSource: resolveCacheDataSource())
    }
    
    private func resolveSchedulerProvider() -> SchedulerProviderProtocol {
        schedulerProvider = schedulerProvider ?? DefaultSchedulerProvider()
        
        return schedulerProvider!
    }
}
