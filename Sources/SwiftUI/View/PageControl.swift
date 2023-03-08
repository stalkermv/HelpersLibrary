//
//  Created by Valeriy Malishevskyi on 05.08.2022.
//

#if canImport(UIKit)
import SwiftUI

public struct PageControl: UIViewRepresentable {
    public var numberOfPages: Int
    @Binding public var currentPage: Int
    
    public init(numberOfPages: Int, currentPage: Binding<Int>) {
        self.numberOfPages = numberOfPages
        self._currentPage = currentPage
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public func makeUIView(context: Context) -> UIPageControl {
        let control = UIPageControl()
        control.numberOfPages = numberOfPages
        control.pageIndicatorTintColor = UIColor.white.withAlphaComponent(0.5)
        control.currentPageIndicatorTintColor = UIColor.white
        control.addTarget(
            context.coordinator,
            action: #selector(Coordinator.updateCurrentPage(sender:)),
            for: .valueChanged
        )
        
        return control
    }
    
    public func updateUIView(_ uiView: UIPageControl, context: Context) {
        uiView.currentPage = currentPage
    }
    
    public final class Coordinator: NSObject {
        var control: PageControl
        
        init(_ control: PageControl) {
            self.control = control
        }
        
        @objc
        func updateCurrentPage(sender: UIPageControl) {
            control.currentPage = sender.currentPage
        }
    }
}
#endif

struct PageControl_Previews: PreviewProvider {
    struct Preview: View {
        @State private var currentPage = 1
        
        var body: some View {
            PageControl(numberOfPages: 5, currentPage: $currentPage)
        }
    }
    
    static var previews: some View {
        Preview()
    }
}
