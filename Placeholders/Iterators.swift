//
//  InfiniteArrayIterator.swift
//  The Cleaning App
//
//  Created by Олег on 10.04.17.
//  Copyright © 2017 Two-212 Apps. All rights reserved.
//

public struct InfiniteIterator<Iterator : IteratorProtocol> : IteratorProtocol {
    
    private let sampleIterator: Iterator
    private var currentIterator: Iterator
    
    public init(_ sample: Iterator) {
        self.sampleIterator = sample
        self.currentIterator = sampleIterator
    }
    
    public mutating func next() -> Iterator.Element? {
        if let next = currentIterator.next() {
            return next
        } else {
            self.currentIterator = sampleIterator
            return currentIterator.next()
        }
    }
    
}

public extension IteratorProtocol {
    
    func infinite() -> InfiniteIterator<Self> {
        return InfiniteIterator(self)
    }
    
}

extension MutableCollection where Indices.Iterator.Element == Index {
    
    /// Shuffles the contents of this collection.
    public mutating func shuffle() {
        let count = self.count
        guard count > 1 else { return }
        for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: count, to: 1, by: -1)) {
            let distance: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            guard distance != 0 else { continue }
            let i = index(firstUnshuffled, offsetBy: distance)
            swap(&self[firstUnshuffled], &self[i])
        }
    }
    
}

extension Sequence {
    
    public func shuffled() -> [Iterator.Element] {
        var shuffling = Array(self)
        shuffling.shuffle()
        return shuffling
    }
    
}
