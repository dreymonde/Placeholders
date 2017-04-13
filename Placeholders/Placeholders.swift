//
//  Placeholders.swift
//  Placeholders
//
//  Created by Олег on 13.04.17.
//  Copyright © 2017 AnySuggestion. All rights reserved.
//

import Foundation

final public class Placeholders {
    
    public var iterator: AnyIterator<String>
    var timer: Timer?
    var action: (String) -> () = { _ in }
    
    public init<StringIterator : IteratorProtocol>(iterator: StringIterator) where StringIterator.Element == String {
        self.iterator = AnyIterator(iterator)
    }
    
    public convenience init(placeholders: [String], options: Options = []) {
        var finalPlaceholders = placeholders
        if options.contains(.shuffle) { finalPlaceholders.shuffle() }
        if options.contains(.infinite) {
            self.init(iterator: finalPlaceholders.makeIterator().infinite())
        } else {
            self.init(iterator: finalPlaceholders.makeIterator())
        }
    }
    
    public struct Options : OptionSet {
        
        public var rawValue: Int
        
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        
        public static var infinite = Options(rawValue: 1 << 0)
        public static var shuffle = Options(rawValue: 1 << 1)
        
    }
    
    deinit {
        timer?.invalidate()
    }
    
    public func start(interval: TimeInterval, fireInitial: Bool, action: @escaping (String) -> ()) {
        self.action = action
        let timer = Timer(timeInterval: interval,
                          target: self,
                          selector: #selector(act(timer:)),
                          userInfo: nil,
                          repeats: true)
        RunLoop.current.add(timer, forMode: .defaultRunLoopMode)
        self.timer = timer
        if fireInitial {
            if let firstPlaceholder = iterator.next() {
                action(firstPlaceholder)
            }
        }
    }
    
    @objc private func act(timer: Timer) {
        if let nextPlaceholder = iterator.next() {
            action(nextPlaceholder)
        } else {
            timer.invalidate()
        }
    }
    
}
