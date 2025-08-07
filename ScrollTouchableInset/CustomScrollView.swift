//
//  CustomScrollView.swift
//  ScrollApp
//
//  Created by Благообразова Татьяна on 17.04.2025.
//

import SwiftUI

let colors = [ #colorLiteral(red: 1, green: 0.8288460374, blue: 0.7142352462, alpha: 1), #colorLiteral(red: 0.862490952, green: 0.9275525212, blue: 0.7565410733, alpha: 1), #colorLiteral(red: 0.6587588787, green: 0.9008147717, blue: 0.8110138774, alpha: 1), #colorLiteral(red: 0.8621721864, green: 0.8870885968, blue: 0.9424174428, alpha: 1), #colorLiteral(red: 0.931872189, green: 0.8235704899, blue: 0.9583900571, alpha: 1), #colorLiteral(red: 0.9086051583, green: 0.9786929488, blue: 0.9904000163, alpha: 1), #colorLiteral(red: 0.8369154334, green: 0.9323787093, blue: 0.9993007779, alpha: 1), #colorLiteral(red: 0.9544511437, green: 0.900085032, blue: 0.9097064137, alpha: 1)]

struct CustomScrollView: View {
    
    let items = (1...20).map { "Item \($0)" }
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(0..<50) { index in
                    Color(colors[index % colors.count])
                        .frame(height: 100)
                }
            }
        }
        .overlay {
            userList
        }
        .ignoresSafeArea(.container, edges: .all)
    }
    
    let scrollViewInset: CGFloat = 300
    @State private var offset: CGFloat = 0
    @State var scrollViewRect: CGRect = .zero
    
    private let scrollViewCoordinateSpace = "UserList"
    
    var userList: some View {
        
        ScrollView {
            LazyVStack(spacing: 0) {
                
                Color.clear
                    .frame(height: scrollViewInset, alignment: .center)
                    .onFrameChanged(coordinateSpace: .named(scrollViewCoordinateSpace)) { rect in
                        offset = max(rect.maxY, 0)
                    }
                
                ForEach(0..<50) { i in
                    
                    Text("User \(i)")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                }
            }
        }
        .background(
            Rectangle()
                .fill(.ultraThinMaterial)
                .cornerRadius(24)
                .offset(y: offset)

        )
        .coordinateSpace(.named(scrollViewCoordinateSpace))
        .bindFrameRect(rect: $scrollViewRect)
        .contentShape(
            Rectangle()
                .size(width: scrollViewRect.width, height: scrollViewRect.height - offset)
                .offset(x: 0, y: offset)
        )
    }
}
