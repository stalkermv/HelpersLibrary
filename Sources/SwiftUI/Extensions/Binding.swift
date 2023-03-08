//
//  Created by Valeriy Malishevskyi on 05.08.2022.
//

import SwiftUI

public extension Binding where Value == Bool {
    
    func toggleAction() -> () -> Void {
        return {
            self.wrappedValue.toggle()
        }
    }
    
    func animationToggleAction(_ animation: Animation = .easeInOut) -> () -> Void {
        return {
            withAnimation(animation) {
                self.wrappedValue.toggle()
            }
        }
    }
}

public extension Binding {
    /// Creates a new `Binding` instance with the given value and action.
    ///
    /// - Parameters:
    ///   - value: The value to bind to.
    ///   - action: The action to be called when the binding value is set.
    init(value: Value, action: @escaping () -> Void) {
        self.init(get: { value }, set: { _ in action() } )
    }

    /// Creates a new `Binding` instance with the given value and action.
    ///
    /// - Parameters:
    ///   - value: The value to bind to.
    ///   - action: The action to be called when the binding value is set.
    init(value: Value, action: @escaping (Value) -> Void) {
        self.init(get: { value }, set: { action($0) } )
    }

    /// Creates a new `Binding` instance with the given getter and action.
    ///
    /// - Parameters:
    ///   - get: The getter to use for the binding value.
    ///   - action: The action to be called when the binding value is set.
    init(get: @escaping () -> Value, action: @escaping () -> Void) {
        self.init(get: get, set: { _ in action() })
    }

    /// Creates a new `Binding` instance with the given getter and action.
    ///
    /// - Parameters:
    ///   - get: The getter to use for the binding value.
    ///   - action: The action to be called when the binding value is set.
    init(get: @escaping () -> Value, action: @escaping (Value) -> Void) {
        self.init(get: get, set: { action($0) })
    }

    /// Creates a new `Binding` instance with the given read-only getter.
    ///
    /// - Parameter get: The read-only getter to use for the binding value.
    init(readOnly get: @escaping () -> Value) {
        self.init(get: get, set: { _ in })
    }

    /// Creates a new `Binding` instance with the given value.
    ///
    /// - Parameter value: The value to bind to.
    init(value: Value) {
        self.init(get: { value }, set: { _ in })
    }
}
