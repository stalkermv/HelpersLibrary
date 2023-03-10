//
//  Created by Valeriy Malishevskyi on 25.07.2022.
//

import Foundation

/// A property wrapper that provides a no-op implementation of the Hashable protocol.
@propertyWrapper
public struct HashableNoop<Value: Equatable>: Hashable {
    public var wrappedValue: Value

    public init(wrappedValue value: Value) {
        self.wrappedValue = value
    }

    public func hash(into hasher: inout Hasher) {}
}
