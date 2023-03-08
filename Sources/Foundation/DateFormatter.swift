//
//  Created by Valeriy Malishevskyi on 17.10.2022.
//

import Foundation

public extension DateFormatter {
    /// Returns a string representation, formatted as a relative date from a given date.
    ///
    /// - Parameter date: The date  compared to.
    /// - Returns: A string representation, formatted as a relative date from a given date.
    func relativeString(from date: Date) -> String {
        let isToday = date.isDayEquals(Date())
        
        if isToday {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.doesRelativeDateFormatting = true
            return dateFormatter.string(from: date)
        } else {
            return self.string(from: date)
        }
    }
}
