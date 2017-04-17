//
//  Placeholders.swift
//  Placeholders
//
//  Created by Олег on 13.04.17.
//  Copyright © 2017 AnySuggestion. All rights reserved.
//

import Foundation

public struct PlaceholdersOptions : OptionSet {
    
    public var rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static var infinite = PlaceholdersOptions(rawValue: 1 << 0)
    public static var shuffle = PlaceholdersOptions(rawValue: 1 << 1)
    
}

final public class Placeholders<Element> {
    
    public var iterator: AnyIterator<Element>
    var timer: Timer?
    var action: (Element) -> () = { _ in }
    
    public init<Iterator : IteratorProtocol>(iterator: Iterator) where Iterator.Element == Element {
        self.iterator = AnyIterator(iterator)
    }
    
    public convenience init(placeholders: [Element], options: PlaceholdersOptions = []) {
        var finalPlaceholders = placeholders
        if options.contains(.shuffle) { finalPlaceholders.shuffle() }
        if options.contains(.infinite) {
            self.init(iterator: finalPlaceholders.makeIterator().infinite())
        } else {
            self.init(iterator: finalPlaceholders.makeIterator())
        }
    }
    
    deinit {
        timer?.invalidate()
    }
    
    public func start(interval: TimeInterval, fireInitial: Bool, action: @escaping (Element) -> ()) {
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
