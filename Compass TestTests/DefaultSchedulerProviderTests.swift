//
//  DefaultSchedulerProviderTests.swift
//  Compass TestTests
//
//  Created by Martin Crespi on 05/08/2024.
//

import XCTest

@testable import Compass_Test

final class DefaultSchedulerProviderTests: XCTestCase {
    var schedulerProvider: DefaultSchedulerProvider!
    
    override func setUp() {
        super.setUp()
        
        schedulerProvider = DefaultSchedulerProvider()
    }

    func testDefaultSchedulerProvider_IoQueue() {
        let ioQueue = schedulerProvider.io()
        XCTAssertEqual(ioQueue.qos, .background, "The IO queue should have a background QoS")
    }

    func testDefaultSchedulerProvider_UiQueue() {
        let uiQueue = schedulerProvider.ui()
        XCTAssertEqual(uiQueue, DispatchQueue.main, "The UI queue should be the main queue")
    }
}
