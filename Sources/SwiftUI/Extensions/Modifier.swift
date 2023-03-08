//
//  Created by Valeriy Malishevskyi on 14.09.2022.
//

import SwiftUI

public extension View {

    /// Adds the specified view modifiers to the view based on a boolean condition.
    ///
    /// The modifier function applies the specified view modifiers to the view based on a boolean condition. If the condition is true, the trueCase modifier is applied, otherwise the falseCase modifier is applied. The result is returned as a new view.
    ///
    /// - Parameters:
    /// - condition: A boolean value indicating whether to apply the trueCase modifier or the falseCase modifier.
    /// - trueCase: The view modifier to apply when the condition is true.
    /// - falseCase: The view modifier to apply when the condition is false. The default value is EmptyModifier.
    ///
    /// - Returns: A new view with the specified modifiers applied.
    func modifier<M1: ViewModifier, M2: ViewModifier>(
        on condition: Bool,
        use trueCase: M1,
        default falseCase: M2 = EmptyModifier()
    ) -> some View {
        Group {
            if condition {
                self.modifier(trueCase)
            } else {
                self.modifier(falseCase)
            }
        }
    }
    
    /// Adds the specified view modifiers to the view if the statement is not nil.
    ///
    /// The modifier function applies the specified view modifiers to the view if the statement is not nil. If the statement is not nil, the trueCase modifier is applied, otherwise the falseCase modifier is applied. The result is returned as a new view.
    ///
    /// - Parameters:
    /// - statement: An optional statement to be unwrapped.
    /// - trueCase: A closure that returns the view modifier to apply when the statement is not nil.
    /// - falseCase: The view modifier to apply when the statement is nil. The default value is EmptyModifier.
    ///
    /// - Returns: A new view with the specified modifiers applied.
    func modifier<T, M1: ViewModifier, M2: ViewModifier>(
        unwrapping statement: T?,
        use trueCase: (T) -> M1,
        default falseCase: M2 = EmptyModifier()
    ) -> some View {
        Group {
            if let statement {
                self.modifier(trueCase(statement))
            } else {
                self.modifier(falseCase)
            }
        }
    }
}

public extension View {
    
    func buttonStyle<M1: ButtonStyle, M2: ButtonStyle>(
        on condition: Bool,
        use trueCase: M1,
        default falseCase: M2,
        animation: Animation = .default
    ) -> some View {
        Group {
            if condition {
                self.buttonStyle(trueCase)
            } else {
                self.buttonStyle(falseCase)
            }
        }
        .animation(animation, value: condition)
    }
}
