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
    
    private let mockSightings = [CLLocation(latitude: 36.017200, longitude: -78.883898),
                                 CLLocation(latitude: 36.017782, longitude: -78.882161),
                                 CLLocation(latitude: 36.019344, longitude: -78.883126),
                                 CLLocation(latitude: 36.018859, longitude: -78.882447)]
    private var locationManager: CLLocationManager!
    
    private let maxSightingDistance: Double = 60.96  // 200ft
    private let minSightingDistance: Double = 15.24  // 50ft
    
    @IBOutlet var mapView: MGLMapView!
    @IBOutlet var headerView: NavigationHeaderView!
    
    private var sightings = 0
    private var currentPreserve: Preserve?
    private var currentBounds: MGLCoordinateBounds?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        setUpLocationManager()
        setMapView()
        
        updateHeaderView(with: sightings)
    }
    
    private func setUpLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func setMapView() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.setCenter(CLLocationCoordinate2D(latitude: 36.018467, longitude: -78.883501), zoomLevel: 16.25, animated: false)
        mapView.minimumZoomLevel = 16.0
    }
    
    private func updateHeaderView(with value: Int) {
        let headerText = NSMutableAttributedString.init(string: value == 1 ? "\(value) sighting nearby" : "\(value) sightings nearby")

        // Adds a custom font and size for sightings value in the headerText string
        headerText.setAttributes([NSAttributedString.Key.font: Fonts.bold.withSize(86.0)],
                                 range: NSMakeRange(0, "\(value)".count))
        
        // Vertically centers the 'sightings nearby' description following the sighting value in the headerText string
        headerText.setAttributes([NSAttributedString.Key.baselineOffset: 20.0], range: NSMakeRange("\(value)".count, headerText.length-1))

        headerView.mainLabel.attributedText = headerText
    }
    
    private func updateMonitoredSightings() {
        for sighting in mockSightings {
            if let userLocation = locationManager.location {
                let distance = userLocation.distance(from: sighting)
                
                if distance < maxSightingDistance {
                    addAnnotation(for: sighting)
                } else {
                    removeAnnotation(for: sighting)
                }
            }
        }
    }
    
    private func addAnnotation(for sighting: CLLocation) {
        if let annotation = findAnnotation(for: sighting) {
            mapView.selectAnnotation(annotation, animated: true, completionHandler: nil)
        } else {
            _ = "Animal \(sightings+1)"
            let point = MGLPointAnnotation()
            point.coordinate = sighting.coordinate
            
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            
            mapView.addAnnotation(point)
            
            sightings += 1
            updateHeaderView(with: sightings)
        }
    }
    
    private func removeAnnotation(for sighting: CLLocation) {
        if let annotation = findAnnotation(for: sighting) {
            mapView.removeAnnotation(annotation)
            
            sightings -= 1
            updateHeaderView(with: sightings)
        }
    }
    
    private func findAnnotation(for sighting: CLLocation) -> MGLAnnotation? {
        guard let annotations = mapView.annotations else { return nil }
        for annotation in annotations {
            if annotation.coordinate.latitude == sighting.coordinate.latitude && annotation.coordinate.longitude == sighting.coordinate.longitude {
                return annotation
            }
        }
        return nil
    }
    
}

extension GameMapView: MGLMapViewDelegate {
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        guard annotation is MGLPointAnnotation else { return nil }

        // Use the point annotation’s longitude value (as a string) as the reuse identifier for its view.
        let reuseIdentifier = "\(annotation.coordinate.longitude)"

        // For better performance, always try to reuse existing annotations.
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)

        // If there’s no reusable annotation view available, initialize a new one.
        if annotationView == nil {
            annotationView = SightingAnnotationView(reuseIdentifier: reuseIdentifier)
            annotationView!.bounds = CGRect(x: 0, y: 0, width: 42, height: 42)

            annotationView!.backgroundColor = Colors.lightOrange
        }

        return annotationView
    }

    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
        guard annotation is MGLPointAnnotation else { return }
        
        if let userLocation = locationManager.location {
            let distance = userLocation.distance(from: CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude))
            
            if distance < minSightingDistance {
                guard let delegate = delegate else { return }
                
                let generator = UIImpactFeedbackGenerator(style: .heavy)
                generator.impactOccurred()
                
                delegate.presentSighting()
            }
        }
        
        mapView.deselectAnnotation(annotation, animated: true)
    }
    
    func mapView(_ mapView: MGLMapView, shouldChangeFrom oldCamera: MGLMapCamera, to newCamera: MGLMapCamera) -> Bool {
     
        // Get the current camera to restore it after.
        let currentCamera = mapView.camera
         
        // From the new camera obtain the center to test if it’s inside the boundaries.
        let newCameraCenter = newCamera.centerCoordinate
         
        // Set the map’s visible bounds to newCamera.
        mapView.camera = newCamera
         
        // Revert the camera.
        mapView.camera = currentCamera
         
        // Test if the newCameraCenter is inside currentBounds
        if let currentBounds = currentBounds {
            return MGLCoordinateInCoordinateBounds(newCameraCenter, currentBounds)
        }
        
        return true
    }
    
}

extension GameMapView: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let userLocation = locations.first {
            if let preserve = delegate?.checkForPreserves(near: userLocation) {
                if currentPreserve == nil {
                    mapView.setCenter(CLLocationCoordinate2D(latitude: preserve.center[0], longitude: preserve.center[1]), animated: true)
                }
                currentPreserve = preserve
                
                let sw = CLLocationCoordinate2D(latitude: preserve.bounds["sw"]![0], longitude: preserve.bounds["sw"]![1])
                let ne = CLLocationCoordinate2D(latitude: preserve.bounds["ne"]![0], longitude: preserve.bounds["ne"]![1])
                currentBounds = MGLCoordinateBounds(sw: sw, ne: ne)
            } else {
                currentPreserve = nil
                currentBounds = nil
            }
            
            updateMonitoredSightings()
        }
    }

}
