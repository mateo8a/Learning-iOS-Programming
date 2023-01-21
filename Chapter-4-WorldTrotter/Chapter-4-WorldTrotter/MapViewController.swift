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
    
    override func loadView() {
        mapView = MKMapView()
        view = mapView
        
        addSegmentedControlSubview(view: view)
        addPointsOfInterestSwitch(view: view)
    }
    
    func addSegmentedControlSubview(view: UIView) {
        // Adding segmentedControl to the view
        let segmentedControl = UISegmentedControl(items: ["Standard", "Hybrid", "Satellite"])
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
        let label = UILabel()
        label.text = "Points of interest"
        label.translatesAutoresizingMaskIntoConstraints = false
        let segControl = view.subviews.first { view in
            let testedView = view.self as? UISegmentedControl
            return testedView != nil
        }!

        // Switch
        let uiSwitch = UISwitch()
        uiSwitch.isOn = true
        uiSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        uiSwitch.addTarget(self, action: #selector(pointsOfInterestChanged(_:)), for: .valueChanged)
        
        //Stack
        let stackView = UIStackView(arrangedSubviews: [label, uiSwitch])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        view.addSubview(stackView)
        
        stackView.topAnchor.constraint(equalTo: segControl.bottomAnchor, constant: 10).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    @objc func mapTypeChanged(_ segControl: UISegmentedControl) {
        switch segControl.selectedSegmentIndex {
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
    
    @objc func pointsOfInterestChanged(_ uiSwitch: UISwitch) {
        switch mapView.mapType {
        case .standard:
            var mapConf = MKStandardMapConfiguration()
            toggle(mapConf, uiSwitch)
        case .hybrid:
            var mapConf = MKHybridMapConfiguration()
            toggle(mapConf, uiSwitch)
        default:
            return
        }
    }
    
    func toggle<T: PointsOfInterest>(_ mapConf: T, _ uiSwitch: UISwitch) {
        var newMapConf = mapConf
        if uiSwitch.isOn {
            newMapConf.pointOfInterestFilter = MKPointOfInterestFilter.includingAll
        } else {
            newMapConf.pointOfInterestFilter = MKPointOfInterestFilter.excludingAll
        }
        mapView.preferredConfiguration = newMapConf as! MKMapConfiguration
    }
}
