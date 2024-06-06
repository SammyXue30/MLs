//
//  CustomARViewRepresentable.swift
//  MLs β
//
//  Created by sam on 2023/5/19.
//

import SwiftUI

struct CustomARViewRepresentable: UIViewRepresentable {
    @Binding var lineColor: Color
    @Binding var lineScale: CGFloat
    @Binding var matrixSize: CGFloat
    @Binding var lineSpacing: CGFloat
    
    func makeUIView(context: Context) -> CustomARView {
        return CustomARView(
            lineColor: UIColor(lineColor),
            lineScale: Float(lineScale),
            matrixSize: Int(matrixSize),
            lineSpacing: Float(lineSpacing)
        )
    }
    
    func updateUIView(_ uiView: CustomARView, context: Context) {
        uiView.lineColor = UIColor(lineColor)
        uiView.lineScale = Float(lineScale)
        uiView.matrixSize = Int(matrixSize)
        uiView.lineSpacing = Float(lineSpacing)
        
        uiView.placeLineMatrix()
    }
}
