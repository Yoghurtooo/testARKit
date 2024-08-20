//
//  StateCenter.swift
//  test_ARKit
//
//  Created by ycw on 2024/8/14.
//

import Foundation
import ARKit

class StateCenter: NSObject, ARSessionDelegate {
    static let shared = StateCenter()
    
    private override init() {
        
    }
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        print("ycw: 状态 \(camera.trackingState)")
    }
    
    func sessionShouldAttemptRelocalization(_ session: ARSession) -> Bool {
        //是否要重新定位
        return true
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        //暂停图像处理和设备跟踪
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        //重新开始图像处理和设备跟踪
    }
    
    
}
