//
//  Optional+Unwrap.swift
//  
//
//  Created by Valeriy Malishevskyi on 27.01.2022.
//

import Foundation

public extension Optional {
    /// Unwraps the optional and returns its wrapped value or throws an error.
    ///
    /// - Parameter error: An error to be thrown if the optional is nil.
    /// - Returns: The wrapped value of the optional.
    /// - Throws: The error passed in as the error parameter if the optional is nil.
    func unwrap(or error: Error) throws -> Wrapped {
        guard let value = self else {
            throw error
        }
        return value
    }
}
