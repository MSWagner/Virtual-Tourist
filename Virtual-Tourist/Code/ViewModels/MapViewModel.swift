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

    private let _pins = MutableProperty<[Pin]>([])
    lazy var pins: Property<[Pin]> = {
        return Property(self._pins)
    }()

    init() {
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        if let pins = try? dataController.viewContext.fetch(fetchRequest) {
            _pins.value = pins
        }
    }

    lazy var searchImagesFor: Action<Void, FlickrPhotoSearchResult, APIError> = {
        Action { geoValues in
            return APIClient.request(.photosSearch(lat: 48.210033, lng: 16.363449, page: 1), type: FlickrPhotoSearchResult.self)
        }
    }()

    func setPin(forNewCoordinate coordinate: CLLocationCoordinate2D) -> Pin {
        let pin = Pin(context: dataController.viewContext)
        pin.latitude = Double(coordinate.latitude)
        pin.longitude = Double(coordinate.longitude)
        try? dataController.viewContext.save()

        setPin(pin)
        return pin
    }

    func setPin(_ pin: Pin) {
        selectedPin.value = pin
    }

    func getPhotoViewModel() -> PhotoCollectionViewModel {
        return PhotoCollectionViewModel(pin: selectedPin)
    }
}
