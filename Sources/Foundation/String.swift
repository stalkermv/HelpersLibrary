//
//  Created by Valeriy Malishevskyi on 25.07.2022.
//

import Foundation
import UIKit

public extension String {
    /// Evaluates whether the receiver matches the given regular expression.
    ///
    /// - Parameter regex: The regular expression pattern to evaluate the receiver against.
    /// - Returns: true if the receiver matches the given regular expression, otherwise false.
    func evaluate(withRegex regex: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
}

// MARK: - Identifiable

extension String: Identifiable {
    public var id: String { self }
}

// MARK: - Base64

public extension String {
    func toBase64() -> String {
        Data(self.utf8).base64EncodedString()
    }
    
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
}

public extension String {
    func convertHTML() -> NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        
        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            return attributedString
        } else {
            return nil
        }
    }
}
