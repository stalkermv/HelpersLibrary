//
//  Created by Valeriy Malishevskyi on 22.12.2022.
//

import SwiftUI

public protocol _SharePreview {
    associatedtype Icon: PreviewRepresentable
    associatedtype Image: PreviewRepresentable
    
    var title: String { get }
    var icon: Self.Icon { get }
    var image: Self.Image { get }
}

extension _SharePreview {
    var isEmpty: Bool { title == "None" }
}

public struct TextSharePreview: _SharePreview {
    public var title: String
    public var icon: EmptyPreviewRepresentable { .init() }
    public var image: EmptyPreviewRepresentable { .init() }
    
    init(_ title: String) {
        self.title = title
    }
}

public struct EmptySharePreview: _SharePreview {
    public var title: String { "None" }
    public var icon: EmptyPreviewRepresentable { .init() }
    public var image: EmptyPreviewRepresentable { .init() }
}

public struct SharePreview<Image, Icon> : _SharePreview
where Image: PreviewRepresentable, Icon: PreviewRepresentable {
    public let title: String
    public var icon: Icon
    public var image: Image
}

public extension SharePreview {
    init<S: StringProtocol>(_ title: S) where Image == EmptyPreviewRepresentable, Icon == EmptyPreviewRepresentable {
        self.title = title.description
        self.icon = EmptyPreviewRepresentable()
        self.image = EmptyPreviewRepresentable()
    }
    
    init<S: StringProtocol>(_ title: S, icon: Icon) where Icon: View, Image == EmptyPreviewRepresentable {
        self.title = title.description
        self.icon = icon
        self.image = EmptyPreviewRepresentable()
    }
    
    init<S: StringProtocol>(_ title: S, image: Image, icon: Icon) where Image: PreviewRepresentable, Icon: PreviewRepresentable {
        self.title = title.description
        self.image = image
        self.icon = icon
    }
}
