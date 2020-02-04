//
//  GameMapView.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 2/3/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import UIKit
import Mapbox

class GameMapView: NibBasedView {
    
    public weak var delegate: GameMapViewControllerDelegate?
    
    @IBOutlet var mapView: MGLMapView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        setMapView()
    }
    
    private func setMapView() {
        mapView.showsUserLocation = true
        mapView.setCenter(CLLocationCoordinate2D(latitude: 36.018097, longitude: -78.882764), zoomLevel: 16.25, animated: false)
    }
    
}
