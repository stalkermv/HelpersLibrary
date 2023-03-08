//
//  Created by Valeriy Malishevskyi on 20.11.2022.
//

import SwiftUI

public extension View {
    
    func popup<OverlayView: View>(
        isPresented: Binding<Bool>,
        dismissOnTapOutside: Bool = true,
        blurRadius: CGFloat = 3,
        blurAnimation: Animation? = .linear,
        @ViewBuilder overlayView: @escaping () -> OverlayView
    ) -> some View {
        blur(radius: isPresented.wrappedValue ? blurRadius : 0)
            .animation(blurAnimation, value: isPresented.wrappedValue)
            .allowsHitTesting(!isPresented.wrappedValue)
            .modifier(OverlayModifier(
                isPresented: isPresented,
                dismissOnTapOutside: dismissOnTapOutside,
                overlayView: overlayView)
            )
    }
}

@available(iOS 15.0, *)
public struct BottomPopupView<Content: View>: View {
    let cornerRadius: CGFloat
    let content: Content

    public init(cornerRadius: CGFloat = 16, @ViewBuilder content: () -> Content) {
        self.cornerRadius = cornerRadius
        self.content = content()
    }
    
    public var body: some View {
        VStack {
            Spacer()
            content
                .background(background)
        }
        .animation(.spring())
        .transition(.move(edge: .bottom))
    }
    
    private var background: some View {
        Color(uiColor: .systemBackground)
            .cornerRadius(cornerRadius, corners: [.topLeft, .topRight])
            .edgesIgnoringSafeArea(.bottom)
    }
}

private struct OverlayModifier<OverlayView: View>: ViewModifier {
    
    @Binding var isPresented: Bool
    private var dismissOnTapOutside: Bool
    @ViewBuilder var overlayView: () -> OverlayView
    
    init(
        isPresented: Binding<Bool>,
        dismissOnTapOutside: Bool,
        @ViewBuilder overlayView: @escaping () -> OverlayView
    ) {
        self._isPresented = isPresented
        self.dismissOnTapOutside = dismissOnTapOutside
        self.overlayView = overlayView
    }
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if isPresented { dismissSheet() }
            if isPresented { overlayView() }
        }
    }

    private func dismissSheet() -> some View {
        ZStack {
            Color.black.opacity(isPresented ? 0.1 : 0)
        }
        .edgesIgnoringSafeArea(.all)
        .onTapGesture(perform: { isPresented = false })
    }
}

struct Popup_Previews: PreviewProvider {
    
    @available(iOS 15.0, *)
    struct Preview: View {
        @State private var isPresented = false
        
        var body: some View {
            ScrollView {
                Text("Some content")
                Button("Present Overlay", action: { isPresented = true })
            }
            .popup(isPresented: $isPresented) {
                BottomPopupView {
                    bottomPopup
                }
            }
        }
        
        private var bottomPopup: some View {
            VStack(alignment: .leading) {
                    Label("First", systemImage: "seal.fill")
                    Label("Second", systemImage: "seal.fill")
                    Label("First", systemImage: "seal.fill")
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    static var previews: some View {
        if #available(iOS 15.0, *) {
            Preview()
        } else {
            // Fallback on earlier versions
        }
    }
}
