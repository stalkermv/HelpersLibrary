//
//  Created by Valeriy Malishevskyi on 05.08.2022.
//

import Foundation
import SwiftUI
import Combine

/// A private struct that conforms to the `ViewModifier` protocol and adds pull-to-refresh functionality to a view.
@available(iOS 15, *)
fileprivate struct PullToRefreshModifier: ViewModifier {
    
    /// A binding to a boolean value that determines whether the view is refreshing.
    @Binding var isRefreshing: Bool
    
    /// A state object that manages the continuation used to resume execution after refreshing.
    @StateObject var handler = ContinuationHandler()

    /// Modifies the content of the view with pull-to-refresh functionality.
    ///
    /// - Parameter content: The content of the view.
    /// - Returns: The modified view with pull-to-refresh functionality.
    func body(content: Content) -> some View {
        content.refreshable {
            await withUnsafeContinuation { (continuation: UnsafeContinuation<Void, Never>) in
                handler.continuation = continuation
                isRefreshing = true
            }
        }
        .onChange(of: isRefreshing) { [handler] newValue in
            if !newValue, handler.continuation != nil {
                handler.continuation?.resume()
                handler.continuation = nil
            }
        }
    }
}

/// A final class that manages the continuation used to resume execution after refreshing.
fileprivate final class ContinuationHandler: ObservableObject {
    var continuation: UnsafeContinuation<Void, Never>?
}

public extension View {
    
    /// Adds pull-to-refresh functionality to a view.
    ///
    /// Use this function to add pull-to-refresh functionality to a view. When the user pulls down on the view, the `isRefreshing` binding will be set to `true`, and execution of the code will pause until the binding is set back to `false`. To resume execution, set the `isRefreshing` binding back to `false`.
    ///
    /// - Parameter isRefreshing: A binding to a boolean value that determines whether the view is refreshing.
    /// - Returns: The modified view with pull-to-refresh functionality.
    @ViewBuilder
    func pullToRefresh(isRefreshing: Binding<Bool>) -> some View {
        if #available(iOS 15, *) {
            self.modifier(PullToRefreshModifier(isRefreshing: isRefreshing))
        } else {
            self
        }
    }
}

struct PullToRefreshModifier_Previews: PreviewProvider {
    struct Preview: View {
        @State private var isRefreshing = false
        
        var body: some View {
            ScrollView {
                Text("Test")
            }
            .pullToRefresh(isRefreshing: $isRefreshing)
        }
    }
    static var previews: some View {
        Preview()
    }
}
