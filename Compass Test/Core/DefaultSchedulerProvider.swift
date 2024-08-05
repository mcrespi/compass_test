//
//  DefaultSchedulerProvider.swift
//  Compass Test
//
//  Created by Martin Crespi on 05/08/2024.
//

import Foundation

class DefaultSchedulerProvider: SchedulerProviderProtocol {
    func io() -> DispatchQueue {
        return DispatchQueue.global(qos: .background)
    }
    
    func ui() -> DispatchQueue {
        return DispatchQueue.main
    }
}
