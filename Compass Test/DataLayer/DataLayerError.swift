//
//  DataLayerError.swift
//  Compass Test
//
//  Created by Martin Crespi on 05/08/2024.
//

import Foundation

enum DataLayerError: Error {
    case networkError(Error)
    case cacheError(Error)
    case decodingError(Error)
    case unknownError(Error)
}
