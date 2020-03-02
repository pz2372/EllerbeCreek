//
//  SightingView.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 2/14/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import UIKit
import ARKit

protocol SightingViewDelegate: class {
    func sightingCompleted(_ completed: Bool)
}

class SightingView: NibBasedView {
    
    public weak var delegate: SightingViewControllerDelegate?
    
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
    
    
    @IBOutlet var sceneView: ARSKView! {
        willSet {
            if let sceneView = newValue {
                sceneView.delegate = self
                
                let scene = SightingScene(size: sceneView.bounds.size)
                scene.scaleMode = .resizeFill
                scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                scene.sightingViewDelegate = self
                sceneView.presentScene(scene)
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
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    @IBAction func dismissButtonAction() {
        sceneView.session.pause()
        
        guard let delegate = delegate else { return }
        delegate.showGameMap()
    }
    
}

extension SightingView: ARSKViewDelegate {
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        print("Session Failed - probably due to lack of camera access")
    }
      
    func sessionWasInterrupted(_ session: ARSession) {
        print("Session interrupted")
    }
      
    func sessionInterruptionEnded(_ session: ARSession) {
        print("Session resumed")
        sceneView.session.run(session.configuration!, options: [.resetTracking, .removeExistingAnchors])
    }
    
    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
        var node: SKNode?
        if let anchor = anchor as? Anchor {
            if let type = anchor.type {
                node = SKSpriteNode(imageNamed: type.rawValue)
                node?.name = type.rawValue
            }
        }
        
        return node
    }
    
}

extension SightingView: SightingViewDelegate {
    
    func sightingCompleted(_ completed: Bool) {
        sceneView.session.pause()
        
        if completed {
            delegate?.showSightingDetail()
        } else {
            delegate?.showGameMap()
        }
    }
    
}
