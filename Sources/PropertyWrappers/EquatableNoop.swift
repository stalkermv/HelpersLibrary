//
//  Created by Valeriy Malishevskyi on 25.07.2022.
//

import Foundation

/// A property wrapper that provides a no-op implementation of the Equatable protocol.
@propertyWrapper
public struct EquatableNoop<Value>: Equatable {
    public var wrappedValue: Value

    public init(wrappedValue value: Value) {
        self.wrappedValue = value
    }

    public static func == (lhs: EquatableNoop<Value>, rhs: EquatableNoop<Value>) -> Bool { true }
}
