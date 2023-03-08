//
//  Created by Valeriy Malishevskyi on 25.07.2022.
//

import Foundation

/// A property wrapper that allows a value to be stored in a specified Storage.
///
/// The StorableValue wrapper provides a convenient way to store and retrieve values from a specified Storage implementation.
///
/// - Note: The Storage implementation must support storing and retrieving data of type T.
@propertyWrapper
public struct StorableValue<T: Codable> {
    public var defaultValue: T
    public var key: String
    @EquatableNoop public var storage: Storage
    private var inMemoryValue: T

    public init(wrappedValue: T, key: String, storage: Storage) {
        self.key = key
        self.defaultValue = wrappedValue
        self.storage = storage
        self.inMemoryValue = defaultValue
        self.wrappedValue = (try? storage.load(key: key)) ?? defaultValue
    }

    public init<K: RawRepresentable>(wrappedValue: T, key: K, storage: Storage) where K.RawValue == String {
        self.init(wrappedValue: wrappedValue, key: key.rawValue, storage: storage)
    }

    public var wrappedValue: T  {
        get { inMemoryValue }
        set {
            inMemoryValue = newValue
            try? storage.save(newValue, key: key)
        }
    }
}

extension StorableValue: Equatable where T: Equatable {}
