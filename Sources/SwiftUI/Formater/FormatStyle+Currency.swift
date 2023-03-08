//
//  Created by Valeriy Malishevskyi on 12.11.2022.
//

import SwiftUI

public protocol Price {
    var nsDecimalValue: NSDecimalNumber { get }
    var currencyCode: String { get }
}

@available(iOS 15.0, *)
public extension FormatStyle where Self == ApplicationCurrency {
    
    static func currency(locale: String = "en-US") -> ApplicationCurrency {
        ApplicationCurrency(localeIdentifier: locale)
    }
}

public struct ApplicationCurrency: FormatStyle {
    public typealias FormatInput = Price
    public typealias FormatOutput = String
    
    private let localeIdentifier: String
    
    private var formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.locale = .init(identifier: "en-US")
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        
        return formatter
    }
    
    init(localeIdentifier: String) {
        self.localeIdentifier = localeIdentifier
    }
    
    /// Creates a `FormatOutput` instance from `value`.
    public func format(_ value: Self.FormatInput) -> Self.FormatOutput {
        formatter.string(from: value.nsDecimalValue) ?? ""
    }

    /// If the format allows selecting a locale, returns a copy of this format with the new locale set. Default implementation returns an unmodified self.
    public func locale(_ locale: Locale) -> Self {
        self
    }
}
