//
//  Created by Valeriy Malishevskyi on 05.08.2022.
//

import SwiftUI

public extension NavigationLink where Label == EmptyView {
    init(destination: Destination, isActive: Binding<Bool>) {
        self.init(destination: destination, isActive: isActive) { EmptyView() }
    }
    
    init(isActive: Binding<Bool>, @ViewBuilder destination: @escaping () -> Destination) {
        self.init(destination: destination(), isActive: isActive) { EmptyView() }
    }
}
