//
//  CustomARView.swift
//  MLs β
//
//  Created by sam on 2023/5/19.
//

import ARKit
import SwiftUI
import RealityKit
import CoreMotion

class CustomARView: ARView, ARSessionDelegate, CMHeadphoneMotionManagerDelegate {
    let headphoneMotionManager = CMHeadphoneMotionManager()
    var rotationCallback: ((CMDeviceMotion) -> Void)?
    var lineColor: UIColor?
    var lineScale: Float?
    var matrixSize: Int?
    var lineSpacing: Float?
    
    required init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
    }
    
    dynamic required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(lineColor: UIColor, lineScale: Float, matrixSize: Int, lineSpacing: Float) {
        self.init(frame: UIScreen.main.bounds)
        self.lineColor = lineColor
        self.lineScale = lineScale
        self.matrixSize = matrixSize
        self.lineSpacing = lineSpacing
        session.delegate = self // Set the session delegate to self
        placeLineMatrix()
    }
    
    func configurationExamples() {
        // Tracks the device relative to it's environment
        let configuration = ARWorldTrackingConfiguration()
        session.run(configuration)
    }
    
    func anchorExamples() {
        // Attach anchors at specific coordinates in the iPhone-centered coordinate system
        let coordinateAnchor = AnchorEntity(world: .zero)
        
        // Add an anchor to the scene
        scene.addAnchor(coordinateAnchor)
    }
    
    
    func placeLineMatrix() {
        for anchor in scene.anchors {
            scene.removeAnchor(anchor)
        }
        
        guard let matrixSize = self.matrixSize, let lineSpacing = self.lineSpacing else {
            print("Error: matrixSize or lineSpacing is nil")
            return
        }
        
        let xOffset: Float = 1
        let yOffset: Float = 1
        let zOffset: Float = 1
        let centerOffset = (Float(matrixSize) * lineSpacing) / 2 - 0.5 * lineSpacing
        let anchor = AnchorEntity(world: .zero) // Create a single anchor
        
        for x in 0..<matrixSize {
            for y in 0..<matrixSize {
                for z in 0..<matrixSize {
                    if let lineEntity = try? Entity.load(named: "Line.usdz") {
                        // Calculate the position of the current Line entity in the matrix
                        let xPos = Float(x) * xOffset * lineSpacing - centerOffset
                        let yPos = Float(y) * yOffset * lineSpacing - centerOffset
                        let zPos = Float(z) * zOffset * lineSpacing - centerOffset - 2
                        lineEntity.position = SIMD3<Float>(xPos, yPos, zPos)
                        
                        // Use lineScale for scaling lineEntity
                        guard let lineScale = self.lineScale else {
                            print("Error: lineScale is nil")
                            return
                        }
                        lineEntity.scale = SIMD3<Float>(lineScale, lineScale, lineScale)
                        
                        // Use lineColor for lineEntity's color
                        guard let lineColor = self.lineColor else {
                            print("Error: lineColor is nil")
                            return
                        }
                        let simpleMaterial = SimpleMaterial(color: lineColor, isMetallic: false)
                        if let modelEntity = lineEntity as? ModelEntity {
                            modelEntity.model?.materials = [simpleMaterial]
                        }
                        
                        anchor.addChild(lineEntity)
                    } else {
                        print("Failed to load Line.usdz")
                    }
                }
            }
        }

        scene.addAnchor(anchor)
    }
    
    // Implement the ARSessionDelegate method to update the anchor's transform
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        // Get the current camera transform
        let cameraTransform = frame.camera.transform
        
        // Convert the simd_float4x4 to Transform
        let transform = Transform(matrix: cameraTransform)
        
        // Update the anchor's transform
        if let anchor = scene.anchors.first {
            anchor.transform = transform
        }
    }
}
