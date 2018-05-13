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
import CoreData

class PhotoCollectionViewModel {

    var pin: MutableProperty<Pin?>

    private var currentFlickrPhotos: FlickrPhotos?

    // MARK: - Init

    init(pin: MutableProperty<Pin?>) {
        self.pin = pin

        pin.producer.startWithValues {  [weak self] pin in
            guard let pin = pin else { return }

            if let photos = pin.photos, photos.count > 0 {

                print("there is a photo")
            } else {
                print("there are no photos")
                self?.currentFlickrPhotos = nil

                let lat = Double(pin.latitude)
                let lng = Double(pin.longitude)

                self?.searchImagesFor.apply((lat, lng, nil)).start()
            }
        }
    }

    // MARK: - Network Requests

    func setNewCollection() {
        guard let pin = pin.value, let currentPhotos = currentFlickrPhotos else { return }

        let nextPage = currentPhotos.page + 1 > currentPhotos.pages ? 1 : currentPhotos.page + 1

        searchImagesFor.apply((pin.latitude, pin.longitude, nextPage)).start()
    }

    lazy var searchImagesFor: Action<(Double, Double, Int?), FlickrPhotoSearchResult, APIError> = {
        return Action { geoValues in
            APIClient
                .request(.photosSearch(lat: geoValues.0, lng: geoValues.1, page: geoValues.2 ?? 1), type: FlickrPhotoSearchResult.self)
                .on { [weak self] (value) in
                    self?.currentFlickrPhotos = value.photos

                    let photos: [Photo] = value.photos.photo.compactMap {
                        print("value.photos.photo.compactMap")
                        let photo = Photo(context: DataController.shared.viewContext)
                        photo.url = URL(string: "https://farm\($0.farm).staticflickr.com/\($0.server)/\($0.id)_\($0.secret)_q.jpg")

                        return photo
                    }

                    // TODO: Implement and Test updating the current pin on View and CoreData
                    if let pin = self?.pin.value, let oldPhotos = pin.photos {
                        oldPhotos.addingObjects(from: photos)
                        try? DataController.shared.viewContext.save()
                        self?.pin.value = pin
                    }
                }
        }
    }()

    // MARK: - Deletion

    func deletePhotoWith(_ indexPath: IndexPath) {
        // TODO: Delete Photos
    }
}
