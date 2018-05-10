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

class MapViewModel {

    private var selectedCoordinate = MutableProperty<CLLocationCoordinate2D?>(nil)

    lazy var searchImagesFor: Action<Void, FlickrPhotoSearchResult, APIError> = {

        Action { geoValues in

            return APIClient.request(.photosSearch(lat: 48.210033, lng: 16.363449, page: 1), type: FlickrPhotoSearchResult.self)

        }
    }()

    func set(_ coordinate: CLLocationCoordinate2D) {
        selectedCoordinate.value = coordinate
    }

    func getPhotoViewModel() -> PhotoCollectionViewModel {
        return PhotoCollectionViewModel(coordinate: selectedCoordinate)
    }
}
