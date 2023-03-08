//
//  Created by Valeriy Malishevskyi on 22.12.2022.
//

import Foundation

@resultBuilder
public enum SharePreviewBuilder {
    public static func buildBlock() -> EmptySharePreview {
        EmptySharePreview()
    }
    
    public static func buildBlock<Content>(_ content: Content) -> Content where Content: _SharePreview {
        content
    }
    
    public static func buildIf<Content>(_ content: Content?) -> _ConditionalContent<Content, EmptySharePreview>
    where Content: _SharePreview {
        if let content {
            return .init(storage: .trueContent(content))
        }
        return .init(storage: .falseContent(EmptySharePreview()))
    }
    
    public static func buildEither<TrueContent, FalseContent>(first: TrueContent) -> _ConditionalContent<TrueContent, FalseContent>
    where TrueContent: _SharePreview, FalseContent: _SharePreview {
        return .init(storage: .trueContent(first))
    }
    
    public static func buildEither<TrueContent, FalseContent>(second: FalseContent) -> _ConditionalContent<TrueContent, FalseContent>
    where TrueContent: _SharePreview, FalseContent: _SharePreview {
        return .init(storage: .falseContent(second))
    }
}

public struct _ConditionalContent<TrueContent, FalseContent>: _SharePreview where TrueContent: _SharePreview, FalseContent: _SharePreview {
    
    public var title: String {
        switch _storage {
        case let .trueContent(content):
            return content.title
        case let .falseContent(content):
            return content.title
        }
    }
    
    public var image: some PreviewRepresentable {
        switch _storage {
        case let .trueContent(content):
            return AnyPreviewRepresentable(content.image)
        case let .falseContent(content):
            return AnyPreviewRepresentable(content.image)
        }
    }
    
    public var icon: some PreviewRepresentable {
        switch _storage {
        case let .trueContent(content):
            return AnyPreviewRepresentable(content.image)
        case let .falseContent(content):
            return AnyPreviewRepresentable(content.image)
        }
    }

    public enum Storage {
        case trueContent(TrueContent)
        case falseContent(FalseContent)
    }
    
    public let _storage: Storage
    
    init(storage: Storage) {
        _storage = storage
    }
}
