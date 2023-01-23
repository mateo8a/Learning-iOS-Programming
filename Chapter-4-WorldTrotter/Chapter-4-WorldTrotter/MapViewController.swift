//
//  MapViewController.swift
//  Chapter-4-WorldTrotter
//
//  Created by Mateo Ochoa on 2023-01-19.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    var mapView: MKMapView!
    var segmentedControl: UISegmentedControl!
    var switchLabel: UILabel!
    var uiSwitch: UISwitch!
    var stackView: UIStackView!
    let locationManager = CLLocationManager()
    var updatedOnce = false
    
    override func loadView() {
        mapView = MKMapView()
        mapView.delegate = self
        view = mapView
                
        addSegmentedControlSubview(view: view)
        addPointsOfInterestSwitch(view: view)
    }
    
    override func viewDidLoad() {
        mapView.showsUserLocation = true
        locationManager.requestWhenInUseAuthorization()
    }
    
    func addSegmentedControlSubview(view: UIView) {
        // Adding segmentedControl to the view
        let standardString = NSLocalizedString("Standard", comment: "standard map view")
        let hybridString = NSLocalizedString("Hybrid", comment: "hybrid map view")
        let satelliteString = NSLocalizedString("Satellite", comment: "satellite map view")
        segmentedControl = UISegmentedControl(items: [standardString, hybridString, satelliteString])
        segmentedControl.backgroundColor = UIColor.systemBackground
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        // Adding constraints to segmentedControl
        let topConstraint = segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8)
        
        let margins = view.layoutMarginsGuide
        let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        
        topConstraint.isActive = true
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
        
        // Adding a target-action pair
        segmentedControl.addTarget(self, action: #selector(mapTypeChanged(_:)), for: .valueChanged)
    }
    
    func addPointsOfInterestSwitch(view: UIView) {
        // Label
        switchLabel = UILabel()
        let pointsOfInterestString = NSLocalizedString("Points of Interest", comment: "the points of interest on the map")
        switchLabel.text = pointsOfInterestString
        switchLabel.translatesAutoresizingMaskIntoConstraints = false

        // Switch
        uiSwitch = UISwitch()
        uiSwitch.isOn = true
        uiSwitch.translatesAutoresizingMaskIntoConstraints = false
        uiSwitch.addTarget(self, action: #selector(pointsOfInterestChanged), for: .valueChanged)
        
        //Stack
        stackView = UIStackView(arrangedSubviews: [switchLabel, uiSwitch])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        view.addSubview(stackView)
        
        stackView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    @objc func mapTypeChanged(_ segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        case 2:
            mapView.mapType = .satellite
        default:
            break
        }
    }
    
    @objc func pointsOfInterestChanged() {
        let mapConf: MKMapConfiguration
        switch mapView.mapType {
        case .standard:
            mapConf = MKStandardMapConfiguration()
            toggle(mapConf)
        case .hybrid:
            let mapConf = MKHybridMapConfiguration()
            toggle(mapConf)
        default:
            return
        }
    }
    
    func toggle(_ mapConf: MKMapConfiguration) {
        var standardMapConf: MKStandardMapConfiguration? = nil
        var hybridMapConf: MKHybridMapConfiguration? = nil
        if let newMapConf = mapConf as? MKStandardMapConfiguration {
            standardMapConf = newMapConf
        } else if let newMapConf = mapConf as? MKHybridMapConfiguration {
            hybridMapConf = newMapConf
        }
        
        if uiSwitch.isOn {
            standardMapConf?.pointOfInterestFilter = MKPointOfInterestFilter.includingAll
            hybridMapConf?.pointOfInterestFilter = MKPointOfInterestFilter.includingAll
        } else {
            standardMapConf?.pointOfInterestFilter = MKPointOfInterestFilter.excludingAll
            hybridMapConf?.pointOfInterestFilter = MKPointOfInterestFilter.excludingAll
        }
        
        if let newMapConf = standardMapConf {
            mapView.preferredConfiguration = newMapConf as MKMapConfiguration
        } else if let newMapConf = hybridMapConf {
            mapView.preferredConfiguration = newMapConf as MKMapConfiguration
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate: MKUserLocation) {
        guard !updatedOnce else { return }
        if let center = didUpdate.location?.coordinate {
            let region = MKCoordinateRegion(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
            updatedOnce = true
        }
    }
}
