//
//  Created by Valeriy Malishevskyi on 25.07.2022.
//

import Foundation

/// A protocol defining a simple key-value storage interface.
///
/// Implementations of Storage can be used to store and retrieve data across an application.
public protocol Storage {
    /// Saves the given object to storage using the specified key.
    ///
    /// - Parameters:
    ///   - object: The object to save.
    ///   - key: The key to use for the object.
    func save<T: Encodable>(_ object: T, key: String) throws

    /// Loads an object from storage using the specified key.
    ///
    /// - Parameter key: The key to use to retrieve the object.
    /// - Returns: The object associated with the specified key, or `nil` if there is no object for the key.
    func load<T: Decodable>(key: String) throws -> T?

    /// Removes the object associated with the specified key from storage.
    ///
    /// - Parameter key: The key to use to remove the object.
    func remove(key: String) throws

    /// Saves the given string to storage using the specified key.
    ///
    /// - Parameters:
    ///   - string: The string to save.
    ///   - key: The key to use for the string.
    func saveString(_ string: String?, key: String) throws

    /// Loads a string from storage using the specified key.
    ///
    /// - Parameter key: The key to use to retrieve the string.
    /// - Returns: The string associated with the specified key, or `nil` if there is no string for the key.
    func loadString(key: String) throws -> String?
}

/// A protocol defining an asynchronous key-value storage interface.
///
/// Implementations of AsyncStorage can be used to store and retrieve data across an application using asynchronous methods.
public protocol AsyncStorage {
    /// Saves the given object to storage using the specified key.
    ///
    /// - Parameters:
    ///   - object: The object to save.
    ///   - key: The key to use for the object.
    func save<T: Encodable>(_ object: T, key: String) async throws

    /// Loads an object from storage using the specified key.
    ///
    /// - Parameter key: The key to use to retrieve the object.
    /// - Returns: The object associated with the specified key, or `nil` if there is no object for the key.
    func load<T: Decodable>(key: String) async throws -> T?

    /// Removes the object associated with the specified key from storage.
    ///
    /// - Parameter key: The key to use to remove the object.
    func remove(key: String) async throws
}
