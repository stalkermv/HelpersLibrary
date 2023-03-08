//
//  Created by Valeriy Malishevskyi on 30.08.2022.
//

import Foundation

/// A storage implementation using the Keychain API to store data.
public final class KeychainStorage: Storage {

    private enum KeychainKey {
        static let serviceName = "bundle.keychain.environment"
        static let environment = "environment"
    }

    private let keychain = Keychain(serviceName: KeychainKey.serviceName, accessMode: kSecAttrAccessibleWhenUnlocked as String)

    /// Sets the data for a given key in the Keychain.
    ///
    /// - Parameters:
    ///   - data: The data to be stored in the Keychain.
    ///   - defaultName: The key to store the data under.
    func set(_ data: Data?, forKey defaultName: String) {
        guard let data = data else { return }
        keychain.addOrUpdate(key: defaultName, data: data)
    }

    /// Returns the data for a given key from the Keychain.
    ///
    /// - Parameter defaultName: The key to retrieve the data for.
    /// - Returns: The data associated with the given key, or nil if there is no data for the key.
    func data(forKey defaultName: String) -> Data? {
        try? keychain.getData(key: defaultName)
    }

    /// Returns the decodable object for a given key from the Keychain.
    ///
    /// - Parameters:
    ///   - type: The type of the decodable object to retrieve.
    ///   - defaultName: The key to retrieve the object for.
    /// - Returns: The decodable object associated with the given key, or nil if there is no object for the key.
    func decodable<T: Decodable>(_ type: T.Type, forKey defaultName: String) -> T? {
        keychain.get(key: defaultName)
    }

    /// Removes the data for a given key from the Keychain.
    ///
    /// - Parameter defaultName: The key to remove the data for.
    func removeObject(forKey defaultName: String) {
        try? keychain.remove(key: defaultName)
    }
}

public extension KeychainStorage {
    func save<T>(_ object: T, key: String) throws where T : Encodable {
        guard let value = try? JSONEncoder().encode(object) else { return }
        set(value, forKey: key)
    }
    
    func load<T>(key: String) throws -> T? where T : Decodable {
        decodable(T.self, forKey: key)
    }
    
    func remove(key: String) throws {
        removeObject(forKey: key)
    }
    
    func saveString(_ string: String?, key: String) throws {
        if let string {
            try keychain.updateValue(key: key, newValue: string)
        } else {
            try keychain.remove(key: key)
        }
    }
    
    func loadString(key: String) throws -> String? {
        try keychain.getValue(key: key)
    }
}

public extension Storage where Self == KeychainStorage {
    
    /// Default variant implementations for `KeyValueStore`
    static var keychain: Storage {
        KeychainStorage()
    }
}
