//
//  ContentView.swift
//  test_ARKit
//
//  Created by ycw on 2024/8/14.
//

import SwiftUI
import RealityKit
import ARKit

struct ContentView : View {
    var body: some View {
        TestEventView().ignoresSafeArea(.all, edges: .all)
    }
}

//struct ARViewContainer: UIViewRepresentable {
//    
//    func makeUIView(context: Context) -> ARView {
//        let arView = ARView(frame: .zero)
//        arView.session.delegate = arView
//        let config = ARWorldTrackingConfiguration()
//        config.planeDetection = .horizontal
//        arView.session.run(config)
//        arView.createPlane()
//        return arView
//    }
//    
//    func updateUIView(_ uiView: ARView, context: Context) {}
//    
//}
//
//// Create a cube model
//var planeMesh = MeshResource.generatePlane(width: 0.15, depth: 0.15)
//var planeMaterial = SimpleMaterial(color: .white, isMetallic: false)
//var planeEntity = ModelEntity(mesh: planeMesh, materials: [planeMaterial])
//var planeAnchor = AnchorEntity()
//
//// Create horizontal plane anchor for the content
//let anchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: SIMD2<Float>(0.2, 0.2)))
//
//extension ARView: ARSessionDelegate {
//    func createPlane() {
//        let planeAnchor = AnchorEntity(plane: .horizontal)
//        do {
//            let cubeMesh = MeshResource.generateBox(size: 0.1)
//            var cubeMaterial = SimpleMaterial(color: .white, isMetallic: false)
//            cubeMaterial.baseColor = try .texture(.load(named: "AR_placement"))
//            let cubeEntity = ModelEntity(mesh: cubeMesh, materials: [cubeMaterial])
//            cubeEntity.generateCollisionShapes(recursive: false)
//            planeAnchor.addChild(cubeEntity)
//            self.scene.addAnchor(planeAnchor)
//            self.installGestures(.all, for: cubeEntity)
//        } catch {
//            
//        }
//    }
//    
//    public func session(_ session: ARSession, didUpdate frame: ARFrame) {
////        guard let result = self.raycast(from: self.center, allowing: .estimatedPlane, alignment: .horizontal).first else { return }
////        
////        planeEntity.setTransformMatrix(result.worldTransform, relativeTo: nil)
//    }
//}

#Preview {
    ContentView()
}
struct TestARCoachView: UIViewRepresentable {
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]
        arView.session.run(config, options: [])
        arView.addCoaching()
        //订阅全部
        arView.scene.subscribe(to: CollisionEvents.Began.self) { event in
            event.entityA
        }
        //订阅单独实体
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        
    }
}

extension ARView: ARCoachingOverlayViewDelegate {
    func addCoaching() {
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(coachingOverlay)
        coachingOverlay.goal = .horizontalPlane
        coachingOverlay.session = self.session
        coachingOverlay.delegate = self
    }
    
    public func coachingOverlayViewWillActivate(_ coachingOverlayView: ARCoachingOverlayView) {
            
    }
    
    public func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
        self.placeBox()
    }
    
    func placeBox() {
        let boxMesh = MeshResource.generateBox(size: 0.1, cornerRadius: 0.005)
        var boxMaterial = SimpleMaterial(color: .gray, roughness: 0.15, isMetallic: true)
        let planeAnchor = AnchorEntity(plane: .horizontal)
        
        do {
//            boxMaterial.color = try .init(tint: .white.withAlphaComponent(0.999), texture: )
            let boxEntity = ModelEntity(mesh: boxMesh, materials: [boxMaterial])
            planeAnchor.addChild(boxEntity)
            self.scene.addAnchor(planeAnchor)
        } catch {
            
        }
    }
}
