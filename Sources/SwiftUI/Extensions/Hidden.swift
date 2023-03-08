//
//  Created by Valeriy Malishevskyi on 27.08.2022.
//

import SwiftUI

public extension View {

    /// Hide or show the view based on a boolean value.
    ///
    /// Example for visibility:
    ///
    ///     Text("Label")
    ///         .hidden(true)
    ///
    /// Example for complete removal:
    ///
    ///     Text("Label")
    ///         .hidden(true, remove: true)
    ///
    /// - Parameters:
    ///   - hidden: Set to `false` to show the view. Set to `true` to hide the view.
    ///   - remove: Boolean value indicating whether or not to remove the view.
    @ViewBuilder func hidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
    
    @ViewBuilder func hidden<V: View>(_ hidden: Bool, remove: Bool = false, placeholder: () -> V) -> some View {
        if hidden {
            if !remove {
                self.hidden()
                .overlay(placeholder())
            } else {
                placeholder()
            }
        } else {
            self
        }
    }
    
    @ViewBuilder func hidden<V: View>(_ hidden: Bool?, remove: Bool = false, placeholder: () -> V) -> some View {
        if let hidden {
            self.hidden(hidden, remove: remove, placeholder: placeholder)
        } else {
            self
        }
    }
}

