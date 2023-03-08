//
//  Created by Valeriy Malishevskyi on 05.08.2022.
//

#if canImport(UIKit)
import SwiftUI

/// An extension of the `View` protocol that provides a function to apply rounded corner masks to a view.
public extension View {
    
    /// Applies a rounded corner mask to the view.
    ///
    /// Use this function to apply a rounded corner mask to a view.
    ///
    /// - Parameters:
    ///   - radius: The radius of the corners of the mask.
    ///   - corners: The corners to apply the mask to.
    /// - Returns: The modified view with the rounded corner mask applied.
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

public struct RoundedCorner: Shape {
    public var radius: CGFloat
    public var corners: UIRectCorner
    
    public init(radius: CGFloat = .infinity, corners: UIRectCorner = .allCorners) {
        self.radius = radius
        self.corners = corners
    }
    
    public func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
#endif
