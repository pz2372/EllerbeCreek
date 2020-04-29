//
//  SessionDetailView.swift
//  EllerbeCreek
//
//  Created by Ryan Anderson on 4/19/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import UIKit
import Mapbox

class SessionDetailView: NibBasedView {
    
    // MARK: Public Variables
    
    public weak var delegate: SessionDetailViewControllerDelegate?
    
    // MARK: Private Variables
    
    private var session: Session!
    
    // MAR: Private Constants
    
    private let gradientLayer: CAGradientLayer = {
              let layer = CAGradientLayer()
              layer.colors = [Colors.white.withAlphaComponent(0).cgColor, Colors.background.cgColor]
              layer.startPoint = CGPoint(x: 0.5, y: 0.0)
              layer.endPoint = CGPoint(x: 0.5, y: 0.6)
              return layer
           }()
    
    // MARK: Interface Objects
    
    @IBOutlet var dismissButton: UIButton! {
        willSet {
            if let button: UIButton = newValue {
                button.setTitle("", for: .normal)
                button.setBackgroundImage(UIImage(named: "Close"), for: .normal)
                
                button.layer.shadowColor = Colors.black.cgColor
                button.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
                button.layer.shadowOpacity = 0.1
                button.layer.shadowRadius = 6.0
            }
        }
    }
    
    @IBOutlet var dateLabel: UILabel! {
        willSet {
            if let label: UILabel = newValue {
                label.font = Fonts.bold.withSize(22.0)
                label.textAlignment = .center
                label.textColor = Colors.black
                
                label.layer.shadowColor = Colors.black.cgColor
                label.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
                label.layer.shadowOpacity = 0.4
                label.layer.shadowRadius = 8.0
            }
        }
    }
    
    @IBOutlet var sightingsTableView: UITableView! {
        willSet {
            if let tableView: UITableView = newValue {
                tableView.backgroundColor = .clear
                tableView.delegate = self
                tableView.dataSource = self
                tableView.separatorStyle = .none
                tableView.showsVerticalScrollIndicator = false
                
                let frame = CGRect(x: 0.0, y: 0.0, width: tableView.frame.width, height: 104.0)
                let sessionHeaderView = SessionHeaderView(session: session, frame: frame)
                sessionHeaderView.session = session
                tableView.tableHeaderView = sessionHeaderView
                
                let sessionTableViewCell = UINib(nibName: Cells.Sighting.name, bundle: nil)
                tableView.register(sessionTableViewCell, forCellReuseIdentifier: Cells.Sighting.id)
            }
        }
    }
    
    @IBOutlet var mapView: MGLMapView! {
        willSet {
            if let mapView: MGLMapView = newValue {
                mapView.delegate = self
                mapView.minimumZoomLevel = 16.0
                mapView.logoView.isHidden = true
                mapView.attributionButton.isHidden = true
                
                mapView.allowsScrolling = false
                mapView.allowsTilting = false
                mapView.allowsRotating = false
                
                guard let preserveCenter = session.preserve.center else { return }
                mapView.setCenter(preserveCenter, animated: true)
                
//                session.sightings.forEach { sighting in
//                    addAnnotation(for: sighting)
//                }
            }
        }
    }
    
    @IBOutlet var sessionDetailHeaderView: SessionHeaderView! {
        willSet {
            if let view: SessionHeaderView = newValue {
                view.session = session
                view.isHidden = true
                view.backgroundColor = Colors.background
            }
        }
    }
    
    // MARK: View Initialization
    
    required init(session: Session) {
        self.session = session
        super.init(frame: .zero)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        mapView.layer.insertSublayer(gradientLayer, at: 1)
            
        dateLabel.text = formattedStringFrom(date: session.date)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let headerView = sightingsTableView.tableHeaderView {
            headerView.frame = CGRect(x: 0.0, y: 0.0, width: sightingsTableView.frame.width, height: 104.0)
        }
        
        gradientLayer.frame = mapView.frame
        sightingsTableView.contentInset = UIEdgeInsets(top: frame.height*0.24, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    // MARK: Button Actions
    
    @IBAction func dismissButtonAction() {
        guard let delegate = delegate else { return }
        delegate.showProfile()
    }
    
    // MARK: Helpers
    
    private func formattedStringFrom(date: Date) -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MMMM"
        let month = dateFormatter.string(from: session.date)
        
        dateFormatter.dateFormat = "dd"
        let day = dateFormatter.string(from: session.date)
        
        dateFormatter.dateFormat = "yyyy"
        let year = dateFormatter.string(from: session.date)
            
        return "\(month) \(day), \(year)"
    }
    
    private func addAnnotation(for sighting: Sighting) {
        let annotation = SightingPointAnnotation(sighting: sighting)
        annotation.coordinate = sighting.location.coordinate
        mapView.addAnnotation(annotation)
    }
   
}

extension SessionDetailView: MGLMapViewDelegate {
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        guard let annotation = annotation as? SightingPointAnnotation else { return nil }

        let reuseIdentifier = "sighting-\(annotation.sighting.id)"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)

        if annotationView == nil {
            annotationView = SightingAnnotationView(reuseIdentifier: reuseIdentifier)
            annotationView!.bounds = CGRect(x: 0, y: 0, width: 21, height: 21)
            annotationView!.backgroundColor = Colors.lightOrange
        }

        return annotationView
    }

    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return false
    }
    
}

extension SessionDetailView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return session.sightings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.Sighting.id) as! SightingTableViewCell
        let index = indexPath.row
        
        let sighting = session.sightings[index]
        
        guard let animalName = sighting.animal.name,
              let animalImage = sighting.animal.image else { return cell }
        
        cell.animalImageView.image = animalImage
        cell.animalNameLabel.text = "\(animalName)"
        cell.pointsLabel.text = "+\(sighting.points)"
        cell.pointsDescriptionLabel.text = session.totalPoints == 1 ? "point" : "points"
        
        return cell
    }
    
}

extension SessionDetailView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let delegate = delegate else { return }
        let index = indexPath.row
        let sighting = session.sightings[index]
        delegate.showSightingDetail(sighting: sighting)
    }
    
}

extension SessionDetailView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y > -(dateLabel.frame.height-32)) {
            dateLabel.layer.shadowColor = UIColor.clear.cgColor
            sessionDetailHeaderView.isHidden = false
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        } else {
            dateLabel.layer.shadowColor = Colors.black.cgColor
            sessionDetailHeaderView.isHidden = true
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.6)
        }
    }
    
}
