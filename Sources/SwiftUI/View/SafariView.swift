//
//  Created by Valeriy Malishevskyi on 05.08.2022.
//

#if canImport(UIKit)
import SafariServices
import SwiftUI

/// A struct that conforms to the `UIViewControllerRepresentable` protocol and provides a `SFSafariViewController` instance to display a webpage.
public struct SafariView: UIViewControllerRepresentable {
    
    /// The type of view controller used to display the webpage.
    public typealias UIViewControllerType = SFSafariViewController
    
    /// The URL of the webpage to display.
    public let url: URL
    
    /// Initializes a new `SafariView` instance with the given URL.
    ///
    /// - Parameter url: The URL of the webpage to display.
    public init(url: URL) {
        self.url = url
    }
    
    /// Creates a new `SFSafariViewController` instance with the given URL.
    ///
    /// - Parameter context: The context in which the view controller is being created.
    /// - Returns: A new `SFSafariViewController` instance with the given URL.
    public func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }
    
    /// Updates the `SFSafariViewController` instance with any changes made to the `SafariView` struct.
    ///
    /// - Parameters:
    ///   - uiViewController: The view controller instance to update.
    ///   - context: The context in which the view controller is being updated.
    public func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}

#endif
