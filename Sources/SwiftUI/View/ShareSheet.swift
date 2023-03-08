//
//  Created by Valeriy Malishevskyi on 14.12.2022.
//

import SwiftUI
import LinkPresentation

//struct ActivityItem<Data, Preview> where Data: RandomAccessCollection, Preview: _SharePreview {
//    var data: Data
//    var preview: (Data.Element) -> Preview
//}

extension View {
    @ViewBuilder
    func shareSheet<Data, Preview>(
        item activityItems: Binding<[ActivityItem<Data, Preview>]?>
    ) -> some View where Preview: _SharePreview {
        #if os(macOS)
        background(ShareSheet(item: activityItems))
        #elseif os(iOS)
        background(ShareSheet(item: activityItems))
        #endif
    }
}

#if os(macOS)

private struct ShareSheet: NSViewRepresentable where Data: RandomAccessCollection {
    @Binding var item: [ActivityItem<Data>]?
        
    public func makeNSView(context: Context) -> SourceView {
        SourceView(item: $item)
    }
    
    public func updateNSView(_ view: SourceView, context: Context) {
        view.item = $item
    }
    
    final class SourceView: NSView, NSSharingServicePickerDelegate, NSSharingServiceDelegate {
        var picker: NSSharingServicePicker?
        
        var item: Binding<ActivityItem?> {
            didSet {
                updateControllerLifecycle(
                    from: oldValue.wrappedValue,
                    to: item.wrappedValue
                )
            }
        }
        
        init(item: Binding<ActivityItem?>) {
            self.item = item
            super.init(frame: .zero)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func updateControllerLifecycle(from oldValue: ActivityItem?, to newValue: ActivityItem?) {
            switch (oldValue, newValue) {
            case (.none, .some):
                presentController()
            case (.some, .none):
                dismissController()
            case (.some, .some), (.none, .none):
                break
            }
        }
        
        func presentController() {
            picker = NSSharingServicePicker(items: item.wrappedValue?.items ?? [])
            picker?.delegate = self
            DispatchQueue.main.async {
                guard self.window != nil else { return }
                self.picker?.show(relativeTo: self.bounds, of: self, preferredEdge: .minY)
            }
        }
        
        func dismissController() {
            item.wrappedValue = nil
        }
        
        func sharingServicePicker(_ sharingServicePicker: NSSharingServicePicker, delegateFor sharingService: NSSharingService) -> NSSharingServiceDelegate? {
            return self
        }
        
        public func sharingServicePicker(_ sharingServicePicker: NSSharingServicePicker, didChoose service: NSSharingService?) {
            sharingServicePicker.delegate = nil
            dismissController()
        }
        
        func sharingServicePicker(_ sharingServicePicker: NSSharingServicePicker, sharingServicesForItems items: [Any], proposedSharingServices proposedServices: [NSSharingService]) -> [NSSharingService] {
            proposedServices
        }
    }
}

#elseif os(iOS)

private struct ShareSheet<Data, Preview>: UIViewControllerRepresentable where Preview: _SharePreview {
    @Binding var item: [ActivityItem<Data, Preview>]?
    
    init(item: Binding<[ActivityItem<Data, Preview>]?>) {
        _item = item
    }
    
    func makeUIViewController(context: Context) -> Representable {
        Representable(item: $item)
    }
    
    func updateUIViewController(_ controller: Representable, context: Context) {
        controller.item = $item
    }
}

private extension ShareSheet {
    final class Representable: UIViewController, UIAdaptivePresentationControllerDelegate, UISheetPresentationControllerDelegate {
        
        private weak var controller: UIActivityViewController?
        private var urlOfImageToShare: URL?
        
        var item: Binding<[ActivityItem<Data, Preview>]?> {
            didSet {
                updateControllerLifecycle(
                    from: oldValue.wrappedValue,
                    to: item.wrappedValue
                )
            }
        }
        
        init(item: Binding<[ActivityItem<Data, Preview>]?>) {
            self.item = item
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func updateControllerLifecycle(from oldValue: [ActivityItem<Data, Preview>]?, to newValue: [ActivityItem<Data, Preview>]?) {
            switch (oldValue, newValue) {
            case (.none, .some):
                presentController()
            case (.some, .none):
                dismissController()
            case (.some, .some), (.none, .none):
                break
            }
        }
        
        private func presentController() {
            let controller = UIActivityViewController(activityItems: item.wrappedValue ?? [] , applicationActivities: nil)
            controller.excludedActivityTypes = [.addToReadingList, .assignToContact, .openInIBooks]
            controller.presentationController?.delegate = self
            controller.popoverPresentationController?.permittedArrowDirections = .any
            controller.popoverPresentationController?.sourceView = view
            controller.completionWithItemsHandler = { [weak self] _, _, _, _ in
                self?.item.wrappedValue = nil
                self?.dismiss(animated: true)
            }
            present(controller, animated: true)
            self.controller = controller
        }
        
        private func dismissController() {
            guard let controller = controller else { return }
            controller.presentingViewController?.dismiss(animated: true)
        }
        
        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            dismissController()
        }
        
//        func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
//            return UIImage()
//        }
//
//        func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
//            return urlOfImageToShare
//        }
//
//        func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
//            return "Test"
//        }
//
//        func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
//            let metadata = LPLinkMetadata()
//
//            metadata.title = "Description of image to share" // Preview Title
//            metadata.originalURL = urlOfImageToShare // determines the Preview Subtitle
//            metadata.url = urlOfImageToShare
//            metadata.imageProvider = NSItemProvider(contentsOf: urlOfImageToShare)
//            metadata.iconProvider = NSItemProvider(contentsOf: urlInTemporaryDirForSharePreviewImage(urlOfImageToShare))
//
//            return metadata
//        }
        
//        func urlInTemporaryDirForSharePreviewImage(_ url: URL?) -> URL? {
//            if let imageURL = url,
//               let data = try? Foundation.Data(contentsOf: imageURL),
//               let image = UIImage(data: data) {
//
//                let applicationTemporaryDirectoryURL = FileManager.default.temporaryDirectory
//                let sharePreviewURL = applicationTemporaryDirectoryURL.appendingPathComponent("sharePreview.png")
//
//                let resizedOpaqueImage = image.adjustedForShareSheetPreviewIconProvider()
//
//                if let data = resizedOpaqueImage.pngData() {
//                    do {
//                        try data.write(to: sharePreviewURL)
//                        return sharePreviewURL
//                    } catch {
//                        print ("Error: \(error.localizedDescription)")
//                    }
//                }
//            }
//            return nil
//        }
    }
}

class ActivityItem<Data, Preview> : NSObject, UIActivityItemSource
where Preview: _SharePreview {

    let data: Data
    let subject: String?
    let message: String?
    let preview: Preview
    
    init(data: Data, subject: String?, message: String?, preview: Preview) {
        self.data = data
        self.subject = subject
        self.message = message
        self.preview = preview
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        subject ?? ""
    }

    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        data
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        data
    }
    
    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        if preview.isEmpty { return nil }
        
        let metadata = LPLinkMetadata()
        
        metadata.title = preview.title
        metadata.imageProvider = preview.image.itemProvider
        metadata.iconProvider = preview.icon.itemProvider
        return metadata
    }
}

private extension UIImage {
    func adjustedForShareSheetPreviewIconProvider() -> UIImage {
        let replaceTransparencyWithColor = UIColor.black // change as required
        let minimumSize: CGFloat = 40.0  // points

        let format = UIGraphicsImageRendererFormat.init()
        format.opaque = true
        format.scale = self.scale

        let imageWidth = self.size.width
        let imageHeight = self.size.height
        let imageSmallestDimension = max(imageWidth, imageHeight)
        let deviceScale = UIScreen.main.scale
        let resizeFactor = minimumSize * deviceScale  / (imageSmallestDimension * self.scale)

        let size = resizeFactor > 1.0
            ? CGSize(width: imageWidth * resizeFactor, height: imageHeight * resizeFactor)
            : self.size

        return UIGraphicsImageRenderer(size: size, format: format).image { context in
            let size = context.format.bounds.size
            replaceTransparencyWithColor.setFill()
            context.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
    
    var url: URL? {
        do {
            let applicationTemporaryDirectoryURL = FileManager.default.temporaryDirectory
            let sharePreviewURL = applicationTemporaryDirectoryURL.appendingPathComponent("QRCode.png")
            
            let data = self.jpegData(compressionQuality: 0.8)
            try data?.write(to: sharePreviewURL)
            return sharePreviewURL
        } catch {
            return nil
        }
    }
}
#endif
//
//final class ExampleActivity: UIActivity {
//    var _activityTitle: String
//    var _activityImage: UIImage?
//    var activityItems = [Any]()
//
//    init(title: String, image: UIImage?) {
//        _activityTitle = title
//        _activityImage = image
//        super.init()
//    }
//
//    override var activityTitle: String? {
//        return _activityTitle
//    }
//
//    override var activityImage: UIImage? {
//        return _activityImage
//    }
//
//    override var activityType: UIActivity.ActivityType {
//        return UIActivity.ActivityType(rawValue: "com.yoursite.yourapp.activity")
//    }
//
//    override class var activityCategory: UIActivity.Category {
//        return .share
//    }
//
//    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
//        return true
//    }
//
//    override func prepare(withActivityItems activityItems: [Any]) {
//        self.activityItems = activityItems
//    }
//
//    override func perform() {
//        activityDidFinish(true)
//    }
//}
