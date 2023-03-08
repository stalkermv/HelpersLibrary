//
//  Created by Valeriy Malishevskyi on 14.09.2022.
//

import Foundation


public extension Sequence where Iterator.Element: Hashable {
    /// Returns an array containing only the unique elements of the sequence, in the order in which they first appear.
    ///
    /// - Returns: An array containing only the unique elements of the sequence.
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }
}

public extension Sequence {
    /// Returns an array containing only the unique elements of the sequence, determined by a tag returned from a tagging handler closure.
    ///
    /// - Parameter taggingHandler: A closure that returns a tag for each element of the sequence.
    /// - Returns: An array containing only the unique elements of the sequence, determined by their corresponding tags.
    func unique<T: Hashable>(by taggingHandler: (_ element: Self.Iterator.Element) -> T) -> [Self.Iterator.Element] {
        var knownTags = Set<T>()
        
        return self.filter { element -> Bool in
            let tag = taggingHandler(element)
            
            if !knownTags.contains(tag) {
                knownTags.insert(tag)
                return true
            }
            
            return false
        }
    }
}
