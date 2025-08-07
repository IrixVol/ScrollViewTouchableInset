//
//  FramePreferenceKey.swift
//  ScrollApp
//
//  Created by Благообразова Татьяна on 18.04.2025.
//

import SwiftUI

struct FramePreferenceKey: PreferenceKey {
    
    static var defaultValue = CGRect()
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) { }
}

private struct FrameSizeModifer: ViewModifier {
    
    let coordinateSpace: CoordinateSpace
    
    func body(content: Content) -> some View {
        content.background(
            GeometryReader { geometry in
                Color.clear.preference(key: FramePreferenceKey.self, value: geometry.frame(in: coordinateSpace))
            }
        )
    }
}

private struct FrameBackgroundModifer: ViewModifier {
    
    // Применение GeometryReader меняет геометрию объекта!
    // Чтобы избежать этого, GeometryReader применяют не к самому объекту, а к прозрачному фону
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content.preference(key: FramePreferenceKey.self, value: geometry.frame(in: .global))
        }
    }
}

public extension View {
    
    func onFrameChanged(
        coordinateSpace: CoordinateSpace = .global,
        action: @escaping (CGRect) -> Void
    ) -> some View {
        modifier(FrameSizeModifer(coordinateSpace: coordinateSpace))
            .onPreferenceChange(FramePreferenceKey.self, perform: action)
    }

    func bindFrameRect(rect: Binding<CGRect>?) -> some View {
        self
            .onFrameChanged { value in
                rect?.wrappedValue = value
            }
    }
}
