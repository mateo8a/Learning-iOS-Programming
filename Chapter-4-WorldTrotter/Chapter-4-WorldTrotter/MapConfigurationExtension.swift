//
//  MapConfigurationExtension.swift
//  Chapter-4-WorldTrotter
//
//  Created by Mateo Ochoa on 2023-01-20.
//

import MapKit

protocol PointsOfInterest {
    var pointOfInterestFilter: MKPointOfInterestFilter? { get set }
}

extension MKStandardMapConfiguration: PointsOfInterest {}
extension MKHybridMapConfiguration: PointsOfInterest {}
