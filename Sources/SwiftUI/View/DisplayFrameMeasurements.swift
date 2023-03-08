//
//  Created by Valeriy Malishevskyi on 06.02.2023.
//

import SwiftUI

/// An extension of the `View` protocol that provides a function to debug and display frame measurements of a view.
///
/// Use the `debugDisplayFrameMeasurements` function to display the frame measurements of a view in debug mode. This can be helpful in debugging layout issues.
@available(iOS 15.0, *)
public extension View {
    
    /// Displays the frame measurements of a view in debug mode.
    ///
    /// Use this function to display the frame measurements of a view in debug mode. This can be helpful in debugging layout issues.
    ///
    /// - Returns: A modified view that displays the frame measurements in debug mode.
    func debugDisplayFrameMeasurements() -> some View {
        #if DEBUG
        modifier(FrameMeasurementsModifier())
        #else
        self
        #endif
    }
}

/// A private view modifier that adds frame measurement functionality to a view.
@available(iOS 15.0, *)
private struct FrameMeasurementsModifier: ViewModifier {
    
    /// The size of the view.
    @State private var size: CGSize = .zero
    
    /// The body of the view modifier that adds the frame measurement functionality to a view.
    ///
    /// - Parameter content: The content view that the modifier is applied to.
    /// - Returns: The modified view with the frame measurements added.
    func body(content: Content) -> some View {
        content
            .readSize { size in
                self.size = size
            }
            .overlay(measurements)
    }
    
    /// The view that displays the frame measurements.
    private var measurements: some View {
        GeometryReader { proxy in
            Text(size.width, format: .number)
                .background()
                .position(
                    x: proxy.frame(in: .local).midX,
                    y: proxy.frame(in: .local).minY - 10
                )
            
            Text(size.height, format: .number)
                .background()
                .rotationEffect(.degrees(-90))
                .position(
                    x: proxy.frame(in: .local).minX - 10,
                    y: proxy.frame(in: .local).midY
                )
            
            Rectangle()
                .strokeBorder()
        }
        .font(.caption)
    }
}
