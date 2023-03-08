//
//  Created by Valeriy Malishevskyi on 05.08.2022.
//

import SwiftUI

public struct IfLet<Value, Content: View, Placeholder: View> : View {
    public let value: Value?
    public var content: (Value) -> Content
    public var placeholder: () -> Placeholder
    
    public init(value: Value?, @ViewBuilder content: @escaping (Value) -> Content, @ViewBuilder placeholder: @escaping () -> Placeholder) {
        self.value = value
        self.content = content
        self.placeholder = placeholder
    }
    
    public var body: some View {
        if let value {
            content(value)
        } else {
            placeholder()
        }
    }
}

extension IfLet where Placeholder == EmptyView {
    public init(value: Value?, @ViewBuilder content: @escaping (Value) -> Content) {
        self.init(
            value: value,
            content: content,
            placeholder: EmptyView.init
        )
    }
}

struct IfLetView_Previews: PreviewProvider {
    struct DemoView: View {
        let name: String
        
        var body: some View {
            Text("Hello, \(name)")
        }
    }
    
    static let previewName1: String? = "Peter"
    static let previewName2: String? = nil
    
    static var previews: some View {
        IfLet(value: previewName1, content: DemoView.init)
        IfLet(value: previewName2, content: DemoView.init) {
            Text("Placeholder")
        }
        
    }
}
