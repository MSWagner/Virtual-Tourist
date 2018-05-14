//
//  MapViewModel.swift
//  Virtual-Tourist
//
//  Created by Matthias Wagner on 09.05.18.
//  Copyright © 2018 Matthias Wagner. All rights reserved.
//

import Foundation
import ReactiveSwift
import MapKit
import CoreData

class MapViewModel {

    let dataController = DataController.shared

    private var selectedPin = MutableProperty<Pin?>(nil)

    private let _pinAnnotationss = MutableProperty<[PinAnnotation]>([])
    lazy var pinAnnotations: Property<[PinAnnotation]> = {
        return Property(_pinAnnotationss)
    }()

    func fetchPins() {
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        if let pins = try? dataController.viewContext.fetch(fetchRequest) {
            _pinAnnotationss.value = pins.map { PinAnnotation.init(pin: $0) }
            print("Fetched \(pins.count) Pins from CoreData")
        }
    }

    func setPin(forNewCoordinate coordinate: CLLocationCoordinate2D) -> Pin {
        let pin = Pin(context: dataController.viewContext)
        pin.latitude = Double(coordinate.latitude)
        pin.longitude = Double(coordinate.longitude)

        if dataController.saveContext() {
            setPin(pin)
        }

        return pin
    }

    func setPin(_ pin: Pin) {
        selectedPin.value = pin
    }

    func getPhotoViewModel() -> PhotoCollectionViewModel {
        return PhotoCollectionViewModel(pin: selectedPin)
    }
}
