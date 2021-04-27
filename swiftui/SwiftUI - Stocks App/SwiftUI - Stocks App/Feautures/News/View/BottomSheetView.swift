//
//  BottomSheetView.swift
//  SwiftUI - Stocks App
//
//  Created by Jesper Bertelsen on 12/04/2021.
//

import SwiftUI

fileprivate enum constants {
    static let radius:CGFloat = 16
    static let indicatorHeight: CGFloat = 6
    static let indicatorWidth: CGFloat = 60
    static let snapRatio: CGFloat = 0.25
    static let minHeightRatio: CGFloat = 0.2
}

struct BottomSheetView<Content:View>: View {
    @Binding var isOpen: Bool
    
    let maxHeight: CGFloat
    let minHeight: CGFloat
    let content: Content
    
    @GestureState private var translation: CGFloat = 0
    private var offset: CGFloat {
        isOpen ? 0 : maxHeight-minHeight
    }
    
    private var indicator: some View {
        RoundedRectangle(cornerRadius: constants.radius)
            .fill(Color.white.opacity(0.2))
            .frame(width: constants.indicatorWidth, height: constants.indicatorHeight)
            .onTapGesture {
                isOpen.toggle()
            }
    }
    init(isOpen: Binding<Bool>, maxHeight: CGFloat, @ViewBuilder content: () -> Content) {
        self.maxHeight = maxHeight
        self.minHeight = maxHeight * constants.minHeightRatio
        self.content = content()
        self._isOpen = isOpen
    }
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                self.indicator.padding()
                self.content
                
            }.frame(width: geo.size.width, height: maxHeight, alignment: .top)
            .background(ZStack {
                Color.white
                Color.black.opacity(0.8)
            })
            .cornerRadius(constants.radius)
            .frame(height: geo.size.height, alignment: .bottom)
            .offset(y: max(self.offset + self.translation, 0))
            .animation(.interactiveSpring())
            .gesture(DragGesture().updating(self.$translation, body: { (value, state, _) in
                state = value.translation.height
                
            }).onEnded({ value in
                let snapDistance = self.maxHeight * constants.snapRatio
                guard abs(value.translation.height) > snapDistance else {
                    return
                }
                self.isOpen = value.translation.height < 0
            }))
        }
    }
}
