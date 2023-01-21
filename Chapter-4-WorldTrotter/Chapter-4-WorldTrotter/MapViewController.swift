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
    
    override func loadView() {
        mapView = MKMapView()
        view = mapView
        
        addSegmentedControlSubview(view: view)
        addPointsOfInterestSwitch(view: view)
    }
    
    func addSegmentedControlSubview(view: UIView) {
        // Adding segmentedControl to the view
        segmentedControl = UISegmentedControl(items: ["Standard", "Hybrid", "Satellite"])
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
        switchLabel.text = "Points of interest"
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
        switch mapView.mapType {
        case .standard:
            let mapConf = MKStandardMapConfiguration()
            toggle(mapConf)
        case .hybrid:
            let mapConf = MKHybridMapConfiguration()
            toggle(mapConf)
        default:
            return
        }
    }
    
    func toggle<T: PointsOfInterest>(_ mapConf: T) {
        var newMapConf = mapConf
        if uiSwitch.isOn {
            newMapConf.pointOfInterestFilter = MKPointOfInterestFilter.includingAll
        } else {
            newMapConf.pointOfInterestFilter = MKPointOfInterestFilter.excludingAll
        }
        mapView.preferredConfiguration = newMapConf as! MKMapConfiguration
    }
}
