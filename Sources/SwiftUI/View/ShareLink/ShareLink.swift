//
//  Created by Valeriy Malishevskyi on 22.12.2022.
//

import SwiftUI

@available(iOS, deprecated: 16)
@available(macOS, deprecated: 13)
@available(watchOS, deprecated: 9)
@available(tvOS, unavailable)
public struct ShareLink<Data, Preview, Label> : View
where Data: RandomAccessCollection, Label: View, Preview: _SharePreview {
        
    @State private var activities: [ActivityItem<Data.Element, Preview>]?

    let label: Label
    let data: Data
    let subject: String?
    let message: String?
    let preview: (Data.Element) -> Preview

    public var body: some View {
        Button {
            activities = data.map({ ActivityItem(data: $0, subject: subject, message: message, preview: preview($0)) })
        } label: {
            label
        }
        .shareSheet(item: $activities)
    }
}

public extension ShareLink {
    init<S: StringProtocol>(_ title: S, item: String, subject: String? = nil, message: String? = nil)
    where Preview == TextSharePreview, Data == CollectionOfOne<String>, Label == Text {
        self.label = Text(title)
        self.data = .init(item)
        self.subject = subject
        self.message = message
        self.preview = { .init($0) }
    }

    init(_ titleKey: LocalizedStringKey, item: String, subject: String? = nil, message: String? = nil)
    where Preview == TextSharePreview, Data == CollectionOfOne<String>, Label == Text {
        self.label = Text(titleKey)
        self.data = .init(item)
        self.subject = subject
        self.message = message
        self.preview = { .init($0) }
    }

    init(_ title: Text, item: String, subject: String? = nil, message: String? = nil)
    where Preview == TextSharePreview, Data == CollectionOfOne<String>, Label == Text {
        self.label = title
        self.data = .init(item)
        self.subject = subject
        self.message = message
        self.preview = { .init($0) }
    }

    init<S: StringProtocol>(_ title: S, item: URL, subject: String? = nil, message: String? = nil)
    where Preview == TextSharePreview, Data == CollectionOfOne<URL>, Label == Text {
        self.label = Text(title)
        self.data = .init(item)
        self.subject = subject
        self.message = message
        self.preview = { .init($0.absoluteString) }
    }

    init(_ titleKey: LocalizedStringKey, item: URL, subject: String? = nil, message: String? = nil)
    where Preview == TextSharePreview, Data == CollectionOfOne<URL>, Label == Text {
        self.label = Text(titleKey)
        self.data = .init(item)
        self.subject = subject
        self.message = message
        self.preview = { .init($0.absoluteString) }
    }

    init(_ title: Text, item: URL, subject: String? = nil, message: String? = nil)
    where Preview == TextSharePreview, Data == CollectionOfOne<URL>, Label == Text {
        self.label = title
        self.data = .init(item)
        self.subject = subject
        self.message = message
        self.preview = { .init($0.absoluteString) }
    }
    
    init(item: URL, subject: String? = nil, message: String? = nil, @ViewBuilder label: () -> Label)
    where Preview == TextSharePreview, Data == CollectionOfOne<URL> {
        self.label = label()
        self.data = .init(item)
        self.subject = subject
        self.message = message
        self.preview = { .init($0.absoluteString) }
    }

    init(items: Data, subject: String? = nil, message: String? = nil, @ViewBuilder label: () -> Label)
    where Preview == TextSharePreview, Data.Element == String {
        self.label = label()
        self.data = items
        self.subject = subject
        self.message = message
        self.preview = { .init($0) }
    }
    
    init(
        items: Data,
        subject: String? = nil,
        message: String? = nil,
        @SharePreviewBuilder preview: @escaping (Data.Element) -> Preview,
        @ViewBuilder label: () -> Label
    ) where Data.Element == Any {
        self.label = label()
        self.data = items
        self.subject = subject
        self.message = message
        self.preview = preview
    }

    init(items: Data, subject: String? = nil, message: String? = nil, @ViewBuilder label: () -> Label)
    where Preview == TextSharePreview, Data.Element == URL {
        self.label = label()
        self.data = items
        self.subject = subject
        self.message = message
        self.preview = { .init($0.absoluteString) }
    }
}
