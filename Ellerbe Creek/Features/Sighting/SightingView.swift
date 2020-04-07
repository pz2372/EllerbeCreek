//
//  SightingView.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 2/14/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import UIKit
import ARKit

class SightingView: NibBasedView {
    
    public weak var delegate: SightingViewControllerDelegate?
    
    private let mockNodeNames = ["frog", "fish", "bird", "beaver"]
    
    private var nodeName: String = ""
    private var nodeModel: SCNNode = SCNNode()
    
    @IBOutlet var dismissButton: UIButton! {
        willSet {
            if let button: UIButton = newValue {
                button.setTitle("", for: .normal)
                button.setImage(UIImage(named: "Close"), for: .normal)
                
                button.layer.shadowColor   = Colors.black.cgColor
                button.layer.shadowOffset  = CGSize(width: 0.0, height: 2.0)
                button.layer.shadowOpacity = 0.1
                button.layer.shadowRadius  = 8.0
            }
        }
    }
    
    
    @IBOutlet var sceneView: ARSCNView! {
        willSet {
            if let sceneView = newValue {
                sceneView.delegate = self
                sceneView.antialiasingMode = .multisampling4X
                sceneView.scene = SCNScene()
            }
        }
    }
    @IBOutlet var instructionsLabel: UILabel! {
        willSet {
            if let label: UILabel = newValue {
                label.textAlignment = .center
                label.numberOfLines = 2
                label.textColor = Colors.white
                label.font = Fonts.semibold.withSize(28.0)

                label.layer.shadowColor = Colors.black.cgColor
                label.layer.shadowRadius = 6.0
                label.layer.shadowOpacity = 1.0
                label.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
                label.layer.masksToBounds = false
                
                label.text = "Tap the animal to \n observe it"
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setUp()
    }
    
    private func setUp() {
        nodeName = mockNodeNames.randomElement() ?? "beaver"
        let modelScene = SCNScene(named: "Assets.scnassets/\(nodeName)/\(nodeName).dae")!
        for child in modelScene.rootNode.childNodes {
            nodeModel.name = nodeName
            nodeModel.addChildNode(child as SCNNode)
        }
        
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    func getParent(_ nodeFound: SCNNode?) -> SCNNode? {
        if let node = nodeFound {
            if node.name == nodeName {
                return node
            } else if let parent = node.parent {
                return getParent(parent)
            }
        }
        return nil
    }
    
    @IBAction func dismissButtonAction() {
        sceneView.session.pause()
        
        guard let delegate = delegate else { return }
        delegate.showGameMap()
    }
    
}

extension SightingView {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: sceneView)

        var hitTestOptions = [SCNHitTestOption: Any]()
        hitTestOptions[SCNHitTestOption.boundingBoxOnly] = true
        let hitResults: [SCNHitTestResult] = sceneView.hitTest(location, options: hitTestOptions)
        
        if let hit = hitResults.first {
          if let node = getParent(hit.node) {
            node.removeFromParentNode()
            
            guard let delegate = delegate else { return }
            sceneView.session.pause()
            delegate.showSightingDetail()
            
            return
          }
        }
        
        let hitResultsFeaturePoints: [ARHitTestResult] = sceneView.hitTest(location, types: .featurePoint)
        if let hit = hitResultsFeaturePoints.first {
            // Get a transformation matrix with the euler angle of the camera
            let rotate = simd_float4x4(SCNMatrix4MakeRotation(sceneView.session.currentFrame!.camera.eulerAngles.y, 0, 1, 0))

            // Combine both transformation matrices
            let finalTransform = simd_mul(hit.worldTransform, rotate)

            // Use the resulting matrix to position the anchor
            sceneView.session.add(anchor: ARAnchor(transform: finalTransform))
        }
    }
    
}

extension SightingView: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if !anchor.isKind(of: ARPlaneAnchor.self) {
            DispatchQueue.main.async {
                let modelClone = self.nodeModel.clone()
                modelClone.position = SCNVector3(0.0, -1.0, -1.0)
                modelClone.scale = SCNVector3(0.075, 0.075, 0.075)

                // Add model as a child of the node
                node.addChildNode(modelClone)
            }
        }
    }
    
}
