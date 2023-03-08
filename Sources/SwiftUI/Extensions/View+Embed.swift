//
//  File.swift
//  
//
//  Created by Valeriy Malishevskyi on 05.08.2022.
//

import SwiftUI

public extension View {
    func embedInNavigationView() -> some View {
        NavigationView { self }
    }
    
    func embedInScrollView(alignment: Alignment = .center) -> some View {
        GeometryReader { proxy in
            ScrollView(showsIndicators: false) {
                self.frame(
                    minHeight: proxy.size.height,
                    maxHeight: .infinity,
                    alignment: alignment
                )
            }
        }
    }
    
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
    
    func embedInNavigationLink<T: View>(link: T?) -> some View {
        IfLet(value: link, content: {
            NavigationLink(destination: $0) {
                self
            }
        }) {
            self
        }
    }
}
