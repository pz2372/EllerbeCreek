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
    @IBOutlet var headerView: NavigationHeaderView!
    
    private var sightings = 3;
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        setMapView()
        setHeaderView()
    }
    
    private func setMapView() {
        mapView.showsUserLocation = true
        mapView.setCenter(CLLocationCoordinate2D(latitude: 36.018097, longitude: -78.882764), zoomLevel: 16.25, animated: false)
        mapView.minimumZoomLevel = 16.0
    }
    
    private func setHeaderView() {
        let headerText = NSMutableAttributedString.init(string: "\(sightings) sightings nearby")

        headerText.setAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 86.0, weight: .bold)],
                                 range: NSMakeRange(0, "\(sightings)".count))
        headerText.setAttributes([NSAttributedString.Key.baselineOffset: 20.0], range: NSMakeRange("\(sightings)".count, headerText.length-1))


        headerView.mainLabel.attributedText = headerText
    }
    
}
