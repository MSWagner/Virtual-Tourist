//
//  MapViewController.swift
//  Virtual-Tourist
//
//  Created by Matthias Wagner on 09.05.18.
//  Copyright © 2018 Matthias Wagner. All rights reserved.
//

import UIKit
import MapKit
import ReactiveSwift
import ReactiveCocoa
import ReactiveMapKit
import Result

class MapViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionViewContainer: UIView!
    @IBOutlet weak var topConstraintContainerView: NSLayoutConstraint!
    @IBOutlet weak var safeAreaBackground: UIView!
    @IBOutlet weak var onSetNewCollectionButton: UIButton!
    
    // MARK: - Properties

    var viewModel = MapViewModel()

    private var collectionViewController: CollectionViewController!
    private var isAnnotationAdded: Bool = false

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self

        setupCollectionViewController()
        setupGestureRecognicer()
        setupDragControlBinding()

        resetContainerView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        isAnnotationAdded = false
    }

    // MARK: - Setup

    private func setupCollectionViewController() {
        collectionViewController = childViewControllers.first as! CollectionViewController
        collectionViewController.viewModel = viewModel.getPhotoViewModel()

        safeAreaBackground.isHidden = true
        onSetNewCollectionButton.isHidden = true
    }

    private func setupGestureRecognicer() {
        let longGestureRegocnizer = UILongPressGestureRecognizer(target: self, action: #selector(addPinToMap(gesture:)))
        mapView.addGestureRecognizer(longGestureRegocnizer)

        longGestureRegocnizer.reactive.stateChanged.producer.startWithValues { (value) in

            switch value.state {
            case .ended,
                 .cancelled,
                 .failed:
                self.isAnnotationAdded = false

            default:
                break
            }
        }
    }

    private func setupDragControlBinding() {
        collectionViewController.dragControl.move.producer.startWithValues { [weak self] moveValue in
            guard let `self` = self else { return }

            if let moveValue = moveValue {

                let maxYValue = self.collectionViewContainer.frame.height
                let lowestYValue = maxYValue - 100
                let nextValue = self.topConstraintContainerView.constant + moveValue

                if nextValue < lowestYValue {
                    self.hidePhotoCollection.apply().start()
                }
            }
        }
    }

    // MARK: - IBActions

    @IBAction func onSetNewCollection(_ sender: Any) {
        collectionViewController.viewModel?.setNewCollection()
    }

    // MARK - Annotation Functions

    @objc private func addPinToMap(gesture: UILongPressGestureRecognizer) {
        if !isAnnotationAdded {
            isAnnotationAdded = true

            let touchPoint = gesture.location(in: mapView)
            let newCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            viewModel.set(newCoordinates)

            let annotation = MKPointAnnotation()
            annotation.coordinate = newCoordinates
            mapView.addAnnotation(annotation)
            mapView.selectAnnotation(annotation, animated: false)

            animateContainerViewUpWith(newCoordinates)
        }
    }

    // MARK: - ContainerView Handler

    private func animateContainerViewUpWith(_ coordinate: CLLocationCoordinate2D) {
        let newCenterCoordinate = CLLocationCoordinate2D(latitude: coordinate.latitude - mapView.region.span.latitudeDelta * 0.4,
                                                         longitude: coordinate.longitude)
        mapView.setCenter(newCenterCoordinate, animated: true)

        topConstraintContainerView.constant = self.collectionViewContainer.frame.height + view.safeAreaInsets.bottom
        safeAreaBackground.isHidden = false
        onSetNewCollectionButton.isHidden = false

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    lazy var hidePhotoCollection: Action<Void, Void, APIError> = {
        return Action { _ in
            return SignalProducer<Void, APIError> { [weak self] (sink, _) in
                guard let `self` = self else { return }

                /// SetButton Height + SafeAreaInset.Bottom + DragControl Height
                let yDragControlBottomWithButtonTop = self.onSetNewCollectionButton.frame.height + self.view.safeAreaInsets.bottom + 50

                self.topConstraintContainerView.constant = yDragControlBottomWithButtonTop

                /// Move DragControl to SetButton
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.layoutIfNeeded()
                }, completion: { _ in

                    self.deselectAllMarks()

                    /// Hide SetButton and DragControl
                    self.safeAreaBackground.isHidden = true
                    self.onSetNewCollectionButton.isHidden = true
                    self.topConstraintContainerView.constant = 0
                    
                    UIView.animate(withDuration: 0.1, animations: {
                        self.view.layoutIfNeeded()
                    }, completion: { _ in
                        sink.sendCompleted()
                    })
                })
            }
        }
    }()

    private func deselectAllMarks() {
        mapView.selectedAnnotations.forEach { annotation in
            mapView.deselectAnnotation(annotation, animated: true)
        }
    }

    private func resetContainerView() {
        topConstraintContainerView.constant = 0
    }
}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotationCoordinate = view.annotation?.coordinate {
            animateContainerViewUpWith(annotationCoordinate)
        }
    }
}
