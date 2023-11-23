//
//  ContentView.swift
//  MLs β
//
//  Created by sam on 2023/5/19.
//

import SwiftUI
import simd

struct ContentView: View {
    @State private var value1: CGFloat = 1  // Line Size
    @State private var value2: CGFloat = 4  // Matrix Size
    @State private var value3: CGFloat = 1  // Spacing
    @State private var prefabColor: Color = Color(UIColor(red: 0/255, green: 255/255, blue: 255/255, alpha: 1))
    @State private var isToggleOn = false
    @State private var dragOffset: CGFloat = 0.0
    @State private var isCapsule = true
    @State private var cornerRadius: CGFloat = 25
    @State private var rectangleOpacity: Double = 1.0
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        ZStack {
            CustomARViewRepresentable(
                lineColor: $prefabColor,
                lineScale: $value1,
                matrixSize: $value2,
                lineSpacing: $value3
            )
            .ignoresSafeArea()
            GeometryReader { geometry in
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(colorScheme == .dark ? Color.black : Color.white)
                            .frame(width: isCapsule ? min(geometry.size.width * 0.45, 150) : min(geometry.size.width * 0.9, 330),
                                   height: isCapsule ? min(geometry.size.width * 0.45, 180)/3 : min(geometry.size.width * 0.9, 330))
                            .padding()
                            .shadow(color: Color.black.opacity(0.7), radius: 10, x: 0, y: 6)
                            .overlay(
                                VStack {
                                    if isCapsule {
                                        Text("Control Panel")
                                            .padding()
                                    } else {
                                        HStack {
                                            Image(systemName: "seal")
                                                .foregroundColor(.gray)
                                                .padding(.leading)
                                            ColorPicker("Line Color", selection: $prefabColor)
                                                .padding()
                                        }
                                        HStack {
                                            Image(systemName: "airpods.gen3")
                                                .foregroundColor(.gray)
                                                .padding(.leading)
                                            Toggle("Head Tracking", isOn: $isToggleOn)
                                                .padding()
                                            
                                        }
                                        HStack {
                                            Image(systemName: "scribble.variable")
                                                .foregroundColor(.gray)
                                                .padding(.leading)
                                            Stepper(value: $value1, in: 0...10, step: 0.5) {
                                                Text("Line Size: \(String(format: "%.1f", value1))")
                                            }
                                            .padding()
                                        }
                                        HStack {
                                            Image(systemName: "square.grid.3x3")
                                                .foregroundColor(.gray)
                                                .padding(.leading)
                                            Stepper(value: $value2, in: 0...10) {
                                                Text("Matrix Size: \(String(format: "%.f", value2))")
                                            }
                                            .padding()
                                        }
                                        HStack {
                                            Image(systemName: "arrow.up.left.and.arrow.down.right")
                                                .foregroundColor(.gray)
                                                .padding(.leading)
                                            Stepper(value: $value3, in: 0...10, step: 0.5) {
                                                Text("Spacing: \(String(format: "%.1f", value3))")
                                            }
                                            .padding()
                                        }
                                    }
                                }
                                    .padding()
                            )
                        if horizontalSizeClass == .compact {
                            Spacer()
                        }
                    }.opacity(rectangleOpacity)
                }
            }
        }
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    let translation = gesture.translation.height
                    if translation >= 0 {
                        dragOffset = min(translation, 50)
                    } else {
                        dragOffset = max(translation, -50)
                    }
                }
                .onEnded { _ in
                    withAnimation(.easeInOut(duration: 0.3)) {
                        if dragOffset > 0 {
                            isCapsule = true
                            cornerRadius = 180/6
                        } else {
                            isCapsule = false
                            cornerRadius = 25
                        }
                    }
                    dragOffset = 0
                }
        )
        .simultaneousGesture(
            TapGesture(count: 2)
                .onEnded { _ in
                    withAnimation {
                        rectangleOpacity = rectangleOpacity > 0.1 ? 0.1 : 1.0
                    }
                }
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .previewInterfaceOrientation(.portrait)
        }
    }
}
