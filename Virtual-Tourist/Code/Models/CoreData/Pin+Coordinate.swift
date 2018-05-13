//
//  Pin+Coordinate.swift
//  Virtual-Tourist
//
//  Created by Matthias Wagner on 13.05.18.
//  Copyright © 2018 Matthias Wagner. All rights reserved.
//

import Foundation
import MapKit

extension Pin {
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
}
