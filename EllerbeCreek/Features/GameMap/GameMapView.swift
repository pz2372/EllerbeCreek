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
    
    public weak var delegate: GameMapViewControllerDelegate? {
        didSet {
            totalPointsView.delegate = delegate
        }
    }
    
    private var locationManager: CLLocationManager!
    
    private let sessionManager = SessionManager.shared
    
    private let maxSightingDistance: Double = 60.96  // 200ft
    private let minSightingDistance: Double = 15.24  // 50ft
    
    @IBOutlet var mapView: MGLMapView!
    
    @IBOutlet var headerView: NavigationHeaderView! {
        willSet {
            if let view: NavigationHeaderView = newValue {
                view.textLabel.font = Fonts.bold.withSize(86.0)
            }
        }
    }
    
    @IBOutlet var headerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var headerViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var totalPointsView: TotalPointsView!
    
    private var visibleSightings: Int {
        return mapView.annotations?.count ?? 0
    }
    private var mapBounds: MGLCoordinateBounds?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = Colors.background
        
        totalPointsView.isHidden = true
        
        setUpLocationManager()
        setMapView()
        
        addNotifcationsToObserve()
        
        updateHeaderView(with: visibleSightings)
    }
    
    private func addNotifcationsToObserve() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleSessionStarting), name: .sessionStarted, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleSessionEnding), name: .sessionEnded, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleSessionSightingsUpdating), name: .sessionSightingsUpdated, object: nil)
    }
    
    @objc private func handleSessionStarting() {
        guard let session = sessionManager.session,
              let preserveBounds = session.preserve.bounds,
              let preserveCenter = session.preserve.center else { return }
        
        totalPointsView.textLabel.text = "\(session.totalPoints)"
        totalPointsView.isHidden = false
        
        mapBounds = MGLCoordinateBounds(sw: preserveBounds.sw, ne: preserveBounds.ne)
        
        mapView.setCenter(preserveCenter, animated: true)
        updateVisibleSightings()
    }
    
    @objc private func handleSessionEnding() {
        totalPointsView.isHidden = true
        
        if let userLocation = mapView.userLocation {
            mapView.setCenter(userLocation.coordinate, animated: true)
        }
        mapBounds = nil
        
        guard let allAnnotations = mapView.annotations else { return }
        mapView.removeAnnotations(allAnnotations)
        
        updateHeaderView(with: visibleSightings)
    }
    
    @objc private func handleSessionSightingsUpdating() {
        guard let session = sessionManager.session else { return }
        totalPointsView.textLabel.text = "\(session.totalPoints)"
    }
    
    private func setUpLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    private func setMapView() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.minimumZoomLevel = 16.0
        mapView.allowsTilting = false
        mapView.attributionButton.isHidden = true
    }
    
    private func updateHeaderView(with value: Int) {
        let detailText = value == 1 ? "sighting nearby" : "sightings nearby"
        headerView.detailTextLabel.text = detailText
        headerView.textLabel.text = "\(value)"

    }
    
    private func updateVisibleSightings() {
        guard let preserve = sessionManager.preserve,
              let preserveSightings = preserve.sightings else { return }
        
        for sighting in preserveSightings {
            if let userLocation = locationManager.location {
                let distance = userLocation.distance(from: sighting.location)

                if distance < maxSightingDistance {
                    addAnnotation(for: sighting)
                } else {
                    removeAnnotation(for: sighting)
                }
            }
        }
    }
    
    private func addAnnotation(for sighting: Sighting) {
        if let annotation = findAnnotation(for: sighting) {
            mapView.selectAnnotation(annotation, animated: true, completionHandler: nil)
        } else {
            let annotation = SightingPointAnnotation(sighting: sighting)
            annotation.coordinate = sighting.location.coordinate
            
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            
            mapView.addAnnotation(annotation)
            
            updateHeaderView(with: visibleSightings)
        }
    }
    
    private func removeAnnotation(for sighting: Sighting) {
        if let annotation = findAnnotation(for: sighting) {
            mapView.removeAnnotation(annotation)
            
            updateHeaderView(with: visibleSightings)
        }
    }
    
    private func findAnnotation(for sighting: Sighting) -> MGLAnnotation? {
        guard let annotations = mapView.annotations else { return nil }
        for annotation in annotations {
            if annotation.coordinate.latitude == sighting.location.coordinate.latitude && annotation.coordinate.longitude == sighting.location.coordinate.longitude {
                return annotation
            }
        }
        return nil
    }
    
    private func updateAnnotations() {
        
    }
    
}

extension GameMapView: MGLMapViewDelegate {
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        guard let annotation = annotation as? SightingPointAnnotation else { return nil }

        let reuseIdentifier = "sighting-\(annotation.sighting.id)"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)

        if annotationView == nil {
            annotationView = SightingAnnotationView(reuseIdentifier: reuseIdentifier)
            annotationView!.bounds = CGRect(x: 0, y: 0, width: 21, height: 21)
            annotationView!.backgroundColor = sessionManager.session!.sightings.filter({$0.id == annotation.sighting.id}).isEmpty ? Colors.lightOrange : Colors.black
        }

        return annotationView
    }

    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
        guard let annotation = annotation as? SightingPointAnnotation else { return }
        
        if let userLocation = locationManager.location {
            let distance = userLocation.distance(from: CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude))
            
            if distance < minSightingDistance {
                guard let delegate = delegate else { return }
                
                let generator = UIImpactFeedbackGenerator(style: .heavy)
                generator.impactOccurred()
                
                delegate.showSightingView(with: annotation.sighting)
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
        if let mapBounds = mapBounds {
            return MGLCoordinateInCoordinateBounds(newCameraCenter, mapBounds)
        }
        
        return true
    }
    
}

extension GameMapView: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let delegate = delegate else { return }
        if let userLocation = locations.first {
            delegate.isAtPreserve(userLocation) { isAtPreserve in
                if isAtPreserve && sessionManager.isSessionInProgress {
                    guard let preserve = sessionManager.preserve,
                          let preserveBounds = preserve.bounds,
                          let preserveCenter = preserve.center else { return }
                    
                    mapBounds = MGLCoordinateBounds(sw: preserveBounds.sw, ne: preserveBounds.ne)
                    
                    mapView.setCenter(preserveCenter, animated: true)
                    updateVisibleSightings()
                } else {
                    if sessionManager.isSessionInProgress {
                        sessionManager.end()
                    }
                    mapView.setCenter(userLocation.coordinate, animated: true)
                    mapBounds = nil
                    
                    guard let allAnnotations = mapView.annotations else { return }
                    mapView.removeAnnotations(allAnnotations)
                }
            }
            
            updateHeaderView(with: visibleSightings)
        }
    }

}
