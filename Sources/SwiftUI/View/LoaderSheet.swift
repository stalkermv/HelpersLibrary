//
//  Created by Valeriy Malishevskyi on 05.08.2022.
//

#if canImport(UIKit)
import SwiftUI

@available(iOS 14.0, *)
public extension View {
    func loaderSheet(
        isPresented: Binding<Bool>,
        title: String = Bundle.main.localizedString(forKey: "Loading...", value: nil, table: nil),
        font: Font = .body,
        indicatorColor: Color = .black,
        titleColor: Color = .black,
        backgroundColor: Color = .white
    ) -> some View {
        self.modifier(
            LoaderSheet(
                isPresented: isPresented.animation(),
                title: title,
                font: font,
                indicatorColor: indicatorColor,
                titleColor: titleColor,
                backgroundColor: backgroundColor
            )
        )
    }
}

@available(iOS 14.0, *)
public struct LoaderSheet: ViewModifier {
    @Binding public var isPresented: Bool
    public let title: String
    public let font: Font
    public let indicatorColor: Color
    public let titleColor: Color
    public let backgroundColor: Color
    
    public init(
        isPresented: Binding<Bool>,
        title: String,
        font: Font,
        indicatorColor: Color,
        titleColor: Color,
        backgroundColor: Color
    ) {
        self._isPresented = isPresented
        self.title = title
        self.font = font
        self.indicatorColor = indicatorColor
        self.titleColor = titleColor
        self.backgroundColor = backgroundColor
    }
    
    public func body(content: Content) -> some View {
        GeometryReader { proxy in
            ZStack {
                content
                    .allowsHitTesting(!self.isPresented)
                    .blur(radius: self.isPresented ? 3 : 0)
                
                if self.isPresented {
                    VStack {
                        ProgressView()
                            .foregroundColor(indicatorColor)
                        Text(self.title)
                            .font(font)
                            .foregroundColor(titleColor)
                    }
                    .frame(width: proxy.size.width / 2, height: proxy.size.height / 5)
                    .background(backgroundColor)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    .transition(AnyTransition.scale.animation(.spring()))
                    .zIndex(100)
                }
            }
        }
    }
}
#endif

struct MyView_Previews: PreviewProvider {
    struct Preview: View {
        @State private var isShow = false
        var body: some View {
            ZStack {
                if #available(iOS 14.0, *) {
                    Button("Show loader", action: { isShow.toggle() })
                        .loaderSheet(isPresented: $isShow)
                } else {
                    // Fallback on earlier versions
                }
            }
        }
    }
    
    static var previews: some View {
        Preview()
    }
}
