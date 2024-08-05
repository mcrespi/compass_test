//
//  CoreProtocols.swift
//  Compass Test
//
//  Created by Martin Crespi on 05/08/2024.
//

import Foundation

protocol SchedulerProviderProtocol {
    /**
     Returns the `DispatchQueue` for IO operations.
     
     - Returns: A valid `DispatchQueue` for IO operations
     */
    func io() -> DispatchQueue

    /**
     Returns the `DispatchQueue` for UI operations.
     
     - Returns: A valid `DispatchQueue` for UI operations
     */
    func ui() -> DispatchQueue
}

protocol DependenciesResolverProtocol {
    /**
     Resolves and returns the instance of `MainViewModel`
     
     - Returns: A valid instance of `MainViewModel`
     */
    func resolveViewModel() -> MainViewModel
}
