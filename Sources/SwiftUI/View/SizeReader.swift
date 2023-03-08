//
//  Created by Valeriy Malishevskyi on 27.08.2022.
//

import SwiftUI

/// A private struct that conforms to the `PreferenceKey` protocol and is used to store the size of a view.
fileprivate struct SizePreferenceKey: PreferenceKey {
    
    /// The default value of the preference.
    static var defaultValue: CGSize = .zero
    
    /// Reduces the values of the preferences.
    ///
    /// - Parameters:
    ///   - value: The current value of the preference.
    ///   - nextValue: A closure that returns the next value of the preference.
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

public extension View {
    
    /// Adds an overlay to the view that reads its size and performs an action with it.
    ///
    /// Use this function to add an overlay to the view that reads its size and performs an action with it. This can be helpful in situations where you need to know the size of the view.
    ///
    /// - Parameter onChange: A closure that will be called with the new size of the view.
    /// - Returns: The modified view with the overlay added.
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        overlay(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
    
    /// Adds an overlay to the view that reads its width and assigns it to a binding.
    ///
    /// Use this function to add an overlay to the view that reads its width and assigns it to a binding. This can be helpful in situations where you need to know the width of the view.
    ///
    /// - Parameter width: A binding to the width of the view.
    /// - Returns: The modified view with the overlay added.
    func readFrameWidth(_ width: Binding<CGFloat>) -> some View {
        readSize { newSize in
            width.wrappedValue = newSize.width
        }
    }
    
    /// Adds an overlay to the view that reads its height and assigns it to a binding.
    ///
    /// Use this function to add an overlay to the view that reads its height and assigns it to a binding. This can be helpful in situations where you need to know the height of the view.
    ///
    /// - Parameter height: A binding to the height of the view.
    /// - Returns: The modified view with the overlay added.
    func readFrameHeight(_ height: Binding<CGFloat>) -> some View {
        readSize { newSize in
            height.wrappedValue = newSize.height
        }
    }
}
