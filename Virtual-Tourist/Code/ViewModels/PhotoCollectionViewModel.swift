//
//  PhotoCollectionViewModel.swift
//  Virtual-Tourist
//
//  Created by Matthias Wagner on 09.05.18.
//  Copyright © 2018 Matthias Wagner. All rights reserved.
//

import Foundation
import ReactiveSwift
import MapKit
import Result

class PhotoCollectionViewModel {

    var coordinate: MutableProperty<CLLocationCoordinate2D?>

    private var currentFlickrPhotos: FlickrPhotos?

    private let _photoURLs = MutableProperty<[URL]>([])
    lazy var photoURLs: Property<[URL]> = {
        return Property(self._photoURLs)
    }()

    // MARK: - Init

    init(coordinate: MutableProperty<CLLocationCoordinate2D?>) {
        self.coordinate = coordinate

        coordinate.producer.startWithValues {  [weak self] geoValues in
            guard let geoValues = geoValues else { return }

            let lat = Double(geoValues.latitude)
            let lng = Double(geoValues.longitude)

            self?.searchImagesFor.apply((lat, lng, nil)).start()
        }
    }

    // MARK: - Network Requests

    func setNewCollection() {
        guard let coordinate = coordinate.value, let currentPhotos = currentFlickrPhotos else { return }

        let lat = Double(coordinate.latitude)
        let lng = Double(coordinate.longitude)

        let nextPage = currentPhotos.page + 1 > currentPhotos.pages ? 1 : currentPhotos.page + 1

        searchImagesFor.apply((lat, lng, nextPage)).start()
    }

    lazy var searchImagesFor: Action<(Double, Double, Int?), FlickrPhotoSearchResult, APIError> = {

        return Action { geoValues in

            APIClient
                .request(.photosSearch(lat: geoValues.0, lng: geoValues.1, page: geoValues.2 ?? 1), type: FlickrPhotoSearchResult.self)
                .on { [weak self] (value) in
                    self?.currentFlickrPhotos = value.photos
                    self?._photoURLs.value = value.photos.photo.compactMap {
                        return URL(string: "https://farm\($0.farm).staticflickr.com/\($0.server)/\($0.id)_\($0.secret)_q.jpg")
                    }
                }
        }
    }()
}
