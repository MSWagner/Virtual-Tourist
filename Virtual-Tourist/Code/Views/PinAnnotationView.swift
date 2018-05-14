//
//  PinAnnotationView.swift
//  Virtual-Tourist
//
//  Created by Matthias Wagner on 13.05.18.
//  Copyright © 2018 Matthias Wagner. All rights reserved.
//

import UIKit
import MapKit

class PinAnnotationView: MKMarkerAnnotationView {

    override var annotation: MKAnnotation? {
        willSet {
            guard newValue != nil else { return }
            clusteringIdentifier = "pinAnnotationClusterId"
            canShowCallout = false
            calloutOffset = CGPoint(x: -5, y: 5)
            markerTintColor = UIColor(red:0.36, green:0.80, blue:0.74, alpha:1.0)
        }
    }
}
