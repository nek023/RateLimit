//
//  ViewController.swift
//  RateLimitDemo
//
//  Created by Katsuma Tanaka on 2015/03/12.
//  Copyright (c) 2015年 Katsuma Tanaka. All rights reserved.
//

import Cocoa
import RateLimit

class ViewController: NSViewController {
    
    // MARK: - Properties
    
    @IBOutlet private weak var button: NSButton!
    
    private var rateLimit: RateLimit!
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rateLimit = RateLimit(interval: 5.0, limit: 3)
        rateLimit.onReset = { [weak self] () in
            self!.button.enabled = true
        }
    }
    
    
    // MARK: - Actions
    
    @IBAction func checkForUpdates(sender: AnyObject) {
        rateLimit.call()
        button.enabled = !rateLimit.exceeded
    }
    
}
