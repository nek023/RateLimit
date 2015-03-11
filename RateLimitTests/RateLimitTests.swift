//
//  RateLimitTests.swift
//  RateLimitTests
//
//  Created by Katsuma Tanaka on 2015/03/12.
//  Copyright (c) 2015年 Katsuma Tanaka. All rights reserved.
//

import Foundation
import XCTest
import RateLimit

class RateLimitTests: XCTestCase {
    
    func testInitialization() {
        let rateLimit = RateLimit(interval: 60.0 * 60.0, limit: 15)
        
        XCTAssertEqual(rateLimit.interval, 60.0 * 60.0)
        XCTAssertEqual(rateLimit.limit, UInt(15))
        XCTAssertFalse(rateLimit.exceeded)
    }
    
    func testConvenienceInitializers() {
        // initWithLimitPerHour:
        var rateLimit = RateLimit(limitPerHour: 15)
        
        XCTAssertEqual(rateLimit.interval, 60.0 * 60.0)
        XCTAssertEqual(rateLimit.limit, UInt(15))
        XCTAssertFalse(rateLimit.exceeded)
        
        // initWithLimitPerMinute:
        rateLimit = RateLimit(limitPerMinutes: 6)
        
        XCTAssertEqual(rateLimit.interval, 60.0)
        XCTAssertEqual(rateLimit.limit, UInt(6))
        XCTAssertFalse(rateLimit.exceeded)
        
        // initWithLimitPerSecond:
        rateLimit = RateLimit(limitPerSecond: 1)
        
        XCTAssertEqual(rateLimit.interval, 1.0)
        XCTAssertEqual(rateLimit.limit, UInt(1))
        XCTAssertFalse(rateLimit.exceeded)
    }
    
    func testRemaining() {
        let rateLimit = RateLimit(interval: 60.0 * 60.0, limit: 15)
        
        XCTAssertEqual(rateLimit.numberOfCalls, UInt(0))
        XCTAssertEqual(rateLimit.remaining, UInt(15))
        
        rateLimit.call()
        
        XCTAssertEqual(rateLimit.numberOfCalls, UInt(1))
        XCTAssertEqual(rateLimit.remaining, UInt(14))
    }
    
    func testRateLimit() {
        let rateLimit = RateLimit(interval: 1.0, limit: 1)
        rateLimit.onReset = {
            XCTAssertEqual(rateLimit.remaining, UInt(1))
            XCTAssertFalse(rateLimit.exceeded)
        }
        
        XCTAssertEqual(rateLimit.remaining, UInt(1))
        XCTAssertFalse(rateLimit.exceeded)
        
        rateLimit.call()
        
        XCTAssertEqual(rateLimit.remaining, UInt(0))
        XCTAssertTrue(rateLimit.exceeded)
        
        let expectation = expectationWithDescription("Rate limit should be reset.")
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            XCTAssertEqual(rateLimit.remaining, UInt(1))
            XCTAssertFalse(rateLimit.exceeded)
            
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10.0, handler: nil)
    }
    
}
