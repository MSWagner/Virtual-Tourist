//
//  PinAnnotation.swift
//  Virtual-Tourist
//
//  Created by Matthias Wagner on 13.05.18.
//  Copyright © 2018 Matthias Wagner. All rights reserved.
//

import MapKit
import ReactiveSwift

class PinAnnotation: NSObject, MKAnnotation {

    // MARK: - MKAnnotation Properties

    let coordinate: CLLocationCoordinate2D
    let pin: Pin

    // MARK: Init

    init(pin: Pin) {
        let latitude = CLLocationDegrees(pin.latitude)
        let longitude = CLLocationDegrees(pin.longitude)

        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.pin = pin
    }
}
