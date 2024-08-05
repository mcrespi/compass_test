//
//  MainDependenciesResolverTests.swift
//  Compass TestTests
//
//  Created by Martin Crespi on 05/08/2024.
//

import XCTest

@testable import Compass_Test

class MainDependenciesResolverTests: XCTestCase {
    var dependenciesResolver: MainDependenciesResolver!
    
    override func setUp() {
        super.setUp()
        
        dependenciesResolver = MainDependenciesResolver.shared
    }
    
    func testMainDependenciesResolver_ShouldReturnSameInstance() {
        let shared1 = MainDependenciesResolver.shared
        let shared2 = MainDependenciesResolver.shared
        
        XCTAssertTrue(shared1 === shared2)
    }
    
    func testMainDependenciesResolver_ShouldResolveViewModelCorrectly() {
        let viewModel = dependenciesResolver.resolveViewModel()
        
        XCTAssertNotNil(viewModel)
    }
}
