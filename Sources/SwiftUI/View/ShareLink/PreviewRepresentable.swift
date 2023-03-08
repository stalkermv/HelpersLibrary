//
//  Created by Valeriy Malishevskyi on 22.12.2022.
//

import Foundation
import UIKit

public protocol PreviewRepresentable {
    var pathExtension: String { get }
    var itemProvider: NSItemProvider? { get }
}

struct AnyPreviewRepresentable: PreviewRepresentable {
    var pathExtension: String
    var itemProvider: NSItemProvider?
    
    init<T>(_ erase: T) where T: PreviewRepresentable {
        self.pathExtension = erase.pathExtension
        self.itemProvider = erase.itemProvider
    }
}

extension String: PreviewRepresentable {
    public var pathExtension: String { "txt" }
    public var itemProvider: NSItemProvider? {
        do {
            let url = URL(fileURLWithPath: NSTemporaryDirectory())
                .appendingPathComponent("\(UUID().uuidString)")
                .appendingPathExtension(pathExtension)
            try write(to: url, atomically: true, encoding: .utf8)
            return .init(contentsOf: url)
        } catch {
            return nil
        }
    }
}

extension UIImage: PreviewRepresentable {
    public var pathExtension: String { "jpg" }
    public var itemProvider: NSItemProvider? {
        do {
            let url = URL(fileURLWithPath: NSTemporaryDirectory())
                .appendingPathComponent("\(UUID().uuidString)")
                .appendingPathExtension(pathExtension)
            let data = jpegData(compressionQuality: 0.8)
            try data?.write(to: url, options: .atomic)
            return .init(contentsOf: url)
        } catch {
            return nil
        }
    }
}

public struct EmptyPreviewRepresentable: PreviewRepresentable {
    public var pathExtension: String { "" }
    public var itemProvider: NSItemProvider? { nil }
}
