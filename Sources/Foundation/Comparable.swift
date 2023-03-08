//
//  Created by Valeriy Malishevskyi on 25.11.2022.
//

import Foundation

public extension Comparable {
    /// Returns the value clamped to the given closed range.
    ///
    /// - Parameter limits: A closed range used as the clamping limits.
    /// - Returns: The value clamped to the given closed range.
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}
