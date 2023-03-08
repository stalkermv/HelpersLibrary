//
//  Created by Valeriy Malishevskyi on 05.08.2022.
//

#if canImport(UIKit)
import SwiftUI

public struct PagerView<Page: View>: View {
    public var pageSelection: Binding<Int>?
    @State private var innerPageSelection = 0
    
    private var pageSelectionBinding: Binding<Int> {
        Binding {
            pageSelection?.wrappedValue ?? innerPageSelection
        } set: { newValue in
            if let pageSelection {
                pageSelection.wrappedValue = newValue
            } else {
                innerPageSelection = newValue
            }
        }
    }
    
    public var pages: [Page]
    private var displayPagesIndicator: Bool = false
    
    @available(iOS 14, *)
    public init(pageSelection: Binding<Int>? = nil, displayPagesIndicator: Bool = true, @ViewBuilder content: () -> Page) {
        self.displayPagesIndicator = displayPagesIndicator
        self.pages = [content()]
        self.pageSelection = pageSelection
    }
    
    public init(pageSelection: Binding<Int>? = nil, pages: [Page]) {
        self.pages = pages
        self.pageSelection = pageSelection
    }
    
    public var body: some View {
        if #available(iOS 14, *) {
            TabView(selection: pageSelectionBinding) {
                ForEach(0..<pages.count, id: \.self) { index in
                    pages[index]
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: displayPagesIndicator ? .always : .never))
        } else {
            PageViewController(
                controllers: pages.map {
                    let hostingController = UIHostingController(rootView: $0)
                    hostingController.view.backgroundColor = .clear
                    return hostingController
                },
                currentPage: pageSelectionBinding
            )
        }
    }
}

struct PagerView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 14, *) {
            PagerView {
                Color.red.tag(0)
                Color.blue.tag(1)
                Color.yellow.tag(2)
            }
        } else {
            PagerView(pages: [
                Color.green,
                Color.blue,
                Color.yellow
            ])
        }
    }
}


private struct PageViewController: UIViewControllerRepresentable {
    var controllers: [UIViewController]
    @Binding var currentPage: Int
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIPageViewController {
        let pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal
        )
        pageViewController.dataSource = context.coordinator
        pageViewController.delegate = context.coordinator
        
        return pageViewController
    }
    
    func updateUIViewController(_ pageViewController: UIPageViewController, context: Context) {
        guard !controllers.isEmpty else {
            return
        }
        context.coordinator.parent = self
        
        if controllers.count != pageViewController.viewControllers?.count {
            pageViewController.setViewControllers([controllers[currentPage]], direction: .forward, animated: false)
        }
    }
    
    final class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
        var parent: PageViewController
        
        init(_ pageViewController: PageViewController) {
            self.parent = pageViewController
        }
        
        func pageViewController(
            _ pageViewController: UIPageViewController,
            viewControllerBefore viewController: UIViewController
        ) -> UIViewController? {
            guard let index = parent.controllers.firstIndex(of: viewController) else {
                return nil
            }
            if index == 0 {
                return parent.controllers.last
            }
            return parent.controllers[index - 1]
        }
        
        func pageViewController(
            _ pageViewController: UIPageViewController,
            viewControllerAfter viewController: UIViewController
        ) -> UIViewController? {
            guard let index = parent.controllers.firstIndex(of: viewController) else {
                return nil
            }
            if index + 1 == parent.controllers.count {
                return parent.controllers.first
            }
            return parent.controllers[index + 1]
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
            if completed,
               let visibleViewController = pageViewController.viewControllers?.first,
               let index = parent.controllers.firstIndex(of: visibleViewController)
            {
                parent.currentPage = index
            }
        }
    }
}
#endif
