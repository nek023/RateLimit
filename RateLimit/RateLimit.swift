//
//  RateLimit.swift
//  Riverflow
//
//  Created by Katsuma Tanaka on 2015/03/11.
//  Copyright (c) 2015年 Katsuma Tanaka. All rights reserved.
//

import Foundation

public class RateLimit: NSObject {
    
    // MARK: - Properties
    
    public let interval: NSTimeInterval
    public let limit: UInt
    
    public var onReset: (() -> Void)?
    public private(set) var numberOfCalls: UInt = 0
    
    public var remaining: UInt {
        return limit - numberOfCalls
    }
    
    public var exceeded: Bool {
        return (numberOfCalls >= limit)
    }
    
    private var timer: NSTimer?
    private var startDate: NSDate?
    
    
    // MARK: - Initializers
    
    public init(interval: NSTimeInterval, limit: UInt) {
        self.interval = interval
        self.limit = limit
        
        super.init()
    }
    
    public convenience init(limitPerHour: UInt) {
        self.init(interval: 60.0 * 60.0, limit: limitPerHour)
    }
    
    public convenience init(limitPerMinutes: UInt) {
        self.init(interval: 60.0, limit: limitPerMinutes)
    }
    
    public convenience init(limitPerSecond: UInt) {
        self.init(interval: 1.0, limit: limitPerSecond)
    }
    
    
    // MARK: - Updating Rate Limit
    
    public func call() -> Bool {
        if exceeded {
            return false
        }
        
        numberOfCalls++
        
        if startDate == nil {
            startDate = NSDate()
            startTimer()
        }
        
        return true
    }
    
    public func reset() {
        stopTimer()
        
        numberOfCalls = 0
        startDate = nil
        
        onReset?()
    }
    
    
    // MARK: - Timer
    
    private func startTimer() {
        stopTimer()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(
            interval,
            target: self,
            selector: "timerFired:",
            userInfo: nil,
            repeats: false
        )
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    internal func timerFired(sender: AnyObject) {
        reset()
    }
    
}
