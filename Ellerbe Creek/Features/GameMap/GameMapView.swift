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
    
    private let mockAnnotationCoordinates = [CLLocationCoordinate2D(latitude: 36.017200, longitude: -78.883898),
                                             CLLocationCoordinate2D(latitude: 36.017782, longitude: -78.882161),
                                             CLLocationCoordinate2D(latitude: 36.019344, longitude: -78.883126)]
    
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
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.setCenter(CLLocationCoordinate2D(latitude: 36.018467, longitude: -78.883501), zoomLevel: 16.25, animated: false)
        mapView.minimumZoomLevel = 16.0
        
        fetchSightings()
    }
    
    private func setHeaderView() {
        let headerText = NSMutableAttributedString.init(string: "\(sightings) sightings nearby")

        // Adds a custom font and size for sightings value in the headerText string
        headerText.setAttributes([NSAttributedString.Key.font: Fonts.bold.withSize(86.0)],
                                 range: NSMakeRange(0, "\(sightings)".count))
        
        // Vertically centers the 'sightings nearby' description following the sighting value in the headerText string
        headerText.setAttributes([NSAttributedString.Key.baselineOffset: 20.0], range: NSMakeRange("\(sightings)".count, headerText.length-1))

        headerView.mainLabel.attributedText = headerText
    }
    
    private func fetchSightings() {
        var pointAnnotations = [MGLPointAnnotation]()
        for (index, coordinate) in mockAnnotationCoordinates.enumerated() {
            let point = MGLPointAnnotation()
            point.coordinate = coordinate
            point.title = "Animal \(index+1)"
            
            pointAnnotations.append(point)
        }
        mapView.addAnnotations(pointAnnotations)
    }
    
}

extension GameMapView: MGLMapViewDelegate {
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        guard annotation is MGLPointAnnotation else {
            return nil
        }
         
        // Use the point annotation’s longitude value (as a string) as the reuse identifier for its view.
        let reuseIdentifier = "\(annotation.coordinate.longitude)"
         
        // For better performance, always try to reuse existing annotations.
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
         
        // If there’s no reusable annotation view available, initialize a new one.
        if annotationView == nil {
            annotationView = SightingAnnotationView(reuseIdentifier: reuseIdentifier)
            annotationView!.bounds = CGRect(x: 0, y: 0, width: 42, height: 42)
             
            // Set the annotation view’s background color to a value determined by its longitude.
            annotationView!.backgroundColor = Colors.lightOrange
        }
         
        return annotationView
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
}
