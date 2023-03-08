//
//  Created by Valeriy Malishevskyi on 25.07.2022.
//

import Foundation

public extension Array {
    
    func sorted<T: Comparable>(keyPath: KeyPath<Element, T>, ascending: Bool = true) -> Self {
        func comparator(_ lhs: T, _ rhs: T, _ comparator: (T, T) -> Bool) -> Bool { comparator(lhs, rhs) }
        
        return sorted { comparator($0[keyPath: keyPath], $1[keyPath: keyPath], ascending ? (<) : (>)) }
    }
    
    func sorted<T: Comparable>(keyPath: KeyPath<Element, T?>, ascending: Bool = true) -> Self {
        sorted {
            guard let lhs = $0[keyPath: keyPath], let rhs = $1[keyPath: keyPath] else {
                return false
            }
            
            return ascending ? lhs < rhs : lhs > rhs
        }
    }
}

public extension Array {
    /// Returns an optional element from the array at the given safe index.
    ///
    /// - Parameter safeIndex: An integer representing the safe index to retrieve the element from.
    /// - Returns: The element at the given safe index, or nil if the index is out of bounds.
    subscript(safeIndex index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }

        return self[index]
    }
}

public extension Array {
    /// Applies a given mutation to each element of an array and returns a new array with the mutated elements.
    ///
    /// - Parameter mutation: A closure that mutates the element of the array.
    /// - Returns: A new array with the mutated elements.
    func mutate(_ mutation: (_ element: inout Element) -> Void) -> [Element] {
        map { element in
            var mutableElement = element
            mutation(&mutableElement)
            return mutableElement
        }
    }
}
