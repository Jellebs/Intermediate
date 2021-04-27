//
//  ContentView.swift
//  Drag Gesture Fun
//
//  Created by Jesper Bertelsen on 27/04/2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            HStack {
                example1()
                    
                example2()
            }
            HStack {
                example8()
                example3()
                    .offset(x: -20)
                example6()
                example5()

            }
             example4()
             example7()
        }
    }
}
//dragGesture
struct example1: View {
    @State private var rectPosition = CGPoint(x: 100, y: 100)
    var body: some View {
       RoundedRectangle(cornerRadius: 20)
        .fill(Color.blue)
        .frame(width: 100, height: 100)
        .position(rectPosition)
        .gesture(
            DragGesture()
                .onChanged { (value) in
                    self.rectPosition = value.location
                }
        )
    }
}
//@gestureState checking for when moving
struct example2: View {
    @GestureState private var isMoving = false
    @State private var rectPosition = CGPoint(x: 100, y: 100)
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Circle()
                    .fill(isMoving ? Color.red : Color.green)
                    .frame(width:50, height: 50)
                Spacer()
            }
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.blue)
                .frame(width: 100, height: 100)
                .position(rectPosition)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            self.rectPosition = value.location
                        }.updating($isMoving, body: { (value, state, transaction) in
                            state = true
                        })
                )
                
        }
        
    }
}
//alarms when dragged into bounds
struct example3: View {
    @State private var rectPosition = CGPoint(x: 100, y: 100)
    @State private var overlapping = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 50)
                .stroke(overlapping ? Color.red : Color.clear, style: StrokeStyle(lineWidth: overlapping ? 40 : 0)
                )
                .edgesIgnoringSafeArea(.all)
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(Color.orange, style: StrokeStyle(lineWidth: overlapping ? 2 : 0)
                )
                .background(overlapping ? Color.clear : Color.orange)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .frame(width: 100, height: 100)
                .position(rectPosition)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            self.rectPosition = value.location
                        }
                        .onEnded { value in
                            if value.location.x < UIScreen.main.bounds.minX + 50 ||
                                value.location.x > UIScreen.main.bounds.maxX  - 50 ||
                                value.location.y < UIScreen.main.bounds.minY + 50 ||
                                value.location.y > UIScreen.main.bounds.maxY - 50 {
                                overlapping = true
                            } else {
                                overlapping = false
                            }
                        }
                )
            
        }
    }
}
//menu slide in
struct example4: View {
    @State private var sliderPosition: CGFloat =  50 - UIScreen.main.bounds.width
    @GestureState private var offset = CGSize.zero
    
    var body: some View {
        GeometryReader { geoReader in
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Image(systemName: "line.horizontal.3")
                        .rotationEffect(.degrees(90))
                        
                }
                .foregroundColor(.white)
                .frame(height: 100)
                .padding()
                .background(
                    ZStack {
                        Rectangle()
                            .fill(Color.orange)
                            .offset(x: -100)
                        Capsule().fill(Color.orange)
                    }
                )
                .offset(x: sliderPosition + offset.width)
                .gesture(
                    DragGesture()
                        .updating($offset, body: { (value, state, transaction) in
                            state = value.translation
                            }
                        )
                        .onEnded { value in
                            if value.translation.width < geoReader.size.width * 0.4 {
                                sliderPosition = 50 - geoReader.size.width
                            } else {
                                sliderPosition = 0
                            }
                        }
                )
                .animation(.spring())
                Spacer()
            }
        }
    }
}
//minDistance
struct example5: View {
    @GestureState private var offset = CGSize.zero
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.orange, lineWidth: 2)
                .frame(width: 100, height: 100)
            Image(systemName: "arrow.right.circle")
                .foregroundColor(.orange)
                .font(.largeTitle)
        }.offset(offset)
        .gesture(
            DragGesture(minimumDistance: 100)
                .updating($offset, body: { (value, state, _) in
                    state = value.translation
                }
            )
        )
    }
}
//pej på centrum
struct example6: View {
    @State private var angle: Angle = .zero
    @State private var offset: CGSize = .zero
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.orange, lineWidth: 4)
                .frame(width: 20, height: 20)
            Image(systemName: "arrow.right.circle.fill")
                .font(.largeTitle)
                .foregroundColor(.orange)
                .rotationEffect(angle)
                .offset(offset)
                .gesture(
                    DragGesture(minimumDistance: 100, coordinateSpace: .local)
                        .onChanged { value in
                            let translation = value.translation
                            let point1 = Double( translation.width)
                            let point2 = Double( translation.height)
                            let a = point1 < 0 ? atan(Double(point2 / point1)) : atan(Double(point2 / point1)) - Double.pi
                            
                            angle = Angle(radians: a)
                            offset = value.translation
                        }.onEnded { value in
                            angle = .zero
                            offset = .zero
                        }
                )
        }
    }
}
//range slider
struct example7: View {
    @State private var minValue: Float = 0
    @State private var maxValue: Float = Float(UIScreen.main.bounds.width - 50)
    
    var body: some View {
        VStack {
            
            DTRangeSlider(
                minValue: $minValue,
                maxValue: $maxValue,
                sliderWidth: CGFloat(maxValue),
                globeMinMaxValuesColor: .black
            )
        }
    }
}
//Lys slider
struct example8: View {
    @State private var maxHeight: CGFloat = 200
    @State private var sliderProgress: CGFloat = 0
    @State private var sliderHeight: CGFloat = 0
    @State private var currentSliderValue: CGFloat = 0
    
    private var labelHeight: CGFloat = 50
    
    var body: some View {
        
        VStack {
            ZStack(alignment: .bottom) {
                Rectangle()
                    .fill(Color.black.opacity(0.3))
                Rectangle()
                    .fill(Color.white)
                    .frame(height: sliderHeight)
            }
            .frame(width: 70, height: maxHeight)
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 2, y: 2)
            .shadow(color: Color.white.opacity(0.2), radius: 5, x: -2, y: -2)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let translation = value.translation
                        
                        sliderHeight = -translation.height + currentSliderValue
                        sliderHeight = sliderHeight > maxHeight ? maxHeight : sliderHeight
                        sliderHeight = sliderHeight >= 0 ? sliderHeight : 0
                        
                        let progress = sliderHeight / maxHeight
                        sliderProgress = progress <= 1.0 ? progress : 1.0
                    }
                    .onEnded { value in
                        sliderHeight = sliderHeight > maxHeight ? maxHeight : sliderHeight
                        sliderHeight = sliderHeight >= 0 ? sliderHeight : 0
                        
                        currentSliderValue = sliderHeight
                    }
                )
            .overlay(
                Image(systemName: (sliderHeight / maxHeight) > 0.5 ? "sun.max.fill" : "sun.min.fill")
                    .font(.largeTitle)
                    .padding(.bottom, 20)
                    .foregroundColor(Color.black.opacity(0.5))
                    .animation(.easeOut)
                ,
                alignment: .bottom
            )
            
        }
    }
    
}
struct DTRangeSlider: View {
    @Binding var minValue: Float
    @Binding var maxValue: Float
    
    @State var sliderWidth: CGFloat
    @State var backgroundTrackColor = Color.green.opacity(0.3)
    @State var selectedTrackColor = Color.orange
    
    @State var globeColor = Color.gray
    @State var globeBackgroundColor = Color.black
    
    @State var globeMinMaxValuesColor = Color.black
    
    var body: some View {
        VStack {
            HStack {
                Text("0")
                    .offset(x: 34, y:10)
                    .frame(width: 30, height: 30, alignment: .leading)
                Spacer()
                Text("Range Slider")
                Spacer()
                
                Text("100")
                    .offset(x: -14, y:10)
                    .frame(width: 30, height: 30, alignment: .leading)
                   
            }
            //Rects og capsules
            ZStack(alignment: Alignment(horizontal: .leading, vertical: .center)) {
                Capsule()
                    .fill(backgroundTrackColor)
                    .frame(width: CGFloat(sliderWidth + 10), height: 20)
                Capsule()
                    .fill(selectedTrackColor)
                    .offset(x: CGFloat(minValue))
                    .frame(width: CGFloat(maxValue - minValue), height: 20)
                // Laveste value - Rect
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(globeColor)
                        .frame(width: 40, height: 40)
                        .background(RoundedRectangle(cornerRadius: 10).stroke(globeBackgroundColor, lineWidth: 3))
                        .offset(x: CGFloat(minValue))
                        .gesture(
                            DragGesture()
                                .onChanged{ value in
                                    if value.location.x > 8 && value.location.x <= sliderWidth && value.location.x < CGFloat(maxValue - 30) {
                                        minValue = Float(value.location.x - 8)
                                    }
                                }
                        )
                    Text(String(format: "%0.0f", CGFloat(minValue) / sliderWidth * 100))
                        .offset(x: CGFloat(minValue))
                        .multilineTextAlignment(.center)
                        .frame(width: 30, height: 30)
                        .foregroundColor(globeMinMaxValuesColor)
                }
                // Højeste value - Rect
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(globeColor)
                        .frame(width: 40, height: 40)
                        .background(RoundedRectangle(cornerRadius: 10).stroke(globeBackgroundColor, lineWidth: 3))
                        .offset(x: CGFloat(maxValue - 18))
                        .gesture(
                            DragGesture()
                                .onChanged{ value in
                                    if value.location.x - 8 <= sliderWidth && value.location.x > CGFloat(minValue + 50) {
                                        maxValue = Float(value.location.x - 8)
                                    }
                                }
                        )
                    Text(String(format: "%0.0f", CGFloat(maxValue) / sliderWidth * 100))
                        .offset(x: CGFloat(maxValue-18))
                        .multilineTextAlignment(.center)
                        .frame(width: 30, height: 30)
                        .foregroundColor(globeMinMaxValuesColor)
                }
            }
            .padding()
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
