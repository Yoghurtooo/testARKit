//
//  TestEventView.swift
//  test_ARKit
//
//  Created by ycw on 2024/8/15.
//

import Foundation
import SwiftUI
import ARKit
import RealityKit
import Combine

struct TestEventView: UIViewRepresentable {
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]
        arView.session.run(config)
        arView.setupGestures()
        arView.debugOptions = [.showWorldOrigin]
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        
    }
}

private extension ARView {
    func setupGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        guard let touchView = sender?.location(in: self) else { return }
        
        guard let raycastQuery = self.makeRaycastQuery(from: touchView, allowing: .existingPlaneInfinite, alignment: .horizontal) else { return }
        
        guard let result = self.session.raycast(raycastQuery).first else { return }
        
        let transformation = Transform(matrix: result.worldTransform)
        let box = CustomEntity(color: .yellow, position: transformation.translation)
        self.installGestures(.all, for: box)
        box.addCollisions(scene: self.scene)
        self.scene.addAnchor(box)
    }
}

class CustomEntity: Entity, HasModel, HasAnchoring, HasCollision {
    var subscribes: [Cancellable] = []
    required init(color: UIColor) {
        super.init()
        self.components[CollisionComponent.self] = CollisionComponent(
            shapes: [.generateBox(size: [0.1,0.1,0.1])],
            mode: .default,
            filter: CollisionFilter(group: CollisionGroup(rawValue: 1), mask: CollisionGroup(rawValue: 1))
        )
        
        self.components[ModelComponent.self] = ModelComponent(
            mesh: .generateBox(size: [0.1,0.1,0.1]),
            materials: [SimpleMaterial(color: color, isMetallic: false)]
        )
    }
    
    convenience init(color: UIColor, position: SIMD3<Float>) {
        self.init(color: color)
        self.position = position
    }
    
    required init() {
        fatalError("没有初始化")
    }
    
    func addCollisions(scene: RealityKit.Scene) {
        subscribes.append(
            scene.subscribe(to: CollisionEvents.Began.self, on: self) { event in
                guard let box = event.entityA as? CustomEntity else {
                    return
                }
                
                box.model?.materials = [SimpleMaterial(color: .red, isMetallic: false)]
            }
        )
        
        subscribes.append(
            scene.subscribe(to: CollisionEvents.Ended.self, on: self) { event in
                guard let box = event.entityA as? CustomEntity else {
                    return
                }
                
                box.model?.materials = [SimpleMaterial(color: .yellow, isMetallic: false)]
            }
        )
    }
}
