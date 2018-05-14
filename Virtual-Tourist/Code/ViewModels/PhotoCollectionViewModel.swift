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

    private var dataController = DataController.shared

    private var selectedPin: MutableProperty<Pin?>
    private var currentFlickrPhotos: FlickrPhotos?

    private let _photos = MutableProperty<[Photo]>([])
    lazy var photos: Property<[Photo]> = {
        return Property(self._photos)
    }()

    // MARK: - Init

    init(pin: MutableProperty<Pin?>) {
        self.selectedPin = pin

        self.selectedPin.producer.startWithValues {  [weak self] pin in
            guard let pin = pin else { return }

            if let photos = pin.photoArray, photos.count > 0 {
                self?._photos.value = photos
            } else {
                self?.currentFlickrPhotos = nil

                self?.searchImagesFor.apply((pin, nil)).start()
            }
        }
    }

    // MARK: - Network Requests

    func setNewCollection() {
        guard let pin = selectedPin.value, let photos = pin.photos else { return }

        pin.removeFromPhotos(photos)
        if !dataController.saveContext() { return }

        if let currentPage = currentFlickrPhotos?.page, let pages = currentFlickrPhotos?.pages {
            let nextPage = currentPage + 1 > pages ? 1 : currentPage + 1
            searchImagesFor.apply((pin, nextPage)).start()
        } else {
            searchImagesFor.apply((pin, 1)).start()
        }
    }

    lazy var searchImagesFor: Action<(Pin, Int?), FlickrPhotoSearchResult, APIError> = {
        return Action { inputValues in

            let pin = inputValues.0
            let page = inputValues.1

            return APIClient
                .request(.photosSearch(lat: pin.latitude, lng: pin.longitude, page: page ?? 1), type: FlickrPhotoSearchResult.self)
                .on { [weak self] (value) in
                    guard let `self` = self else { return }

                    self.currentFlickrPhotos = value.photos

                    let photos: [Photo] = value.photos.photo.compactMap {
                        let photo = Photo(context: DataController.shared.viewContext)
                        photo.url = URL(string: "https://farm\($0.farm).staticflickr.com/\($0.server)/\($0.id)_\($0.secret)_q.jpg")

                        return photo
                    }

                    photos.forEach{ photo in
                        pin.addToPhotos(photo)
                    }

                    if self.dataController.saveContext() {
                        self._photos.value = photos
                    }
                }
        }
    }()

    // MARK: - Deletion

    func deletePhotoWith(_ indexPath: IndexPath) {
        guard let pin = selectedPin.value else { return }

        let removedPhoto = _photos.value.remove(at: indexPath.row)
        pin.removeFromPhotos(removedPhoto)

        if dataController.saveContext() {
            self._photos.value = self._photos.value
        }
    }
}
