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
                let lowestYValue = self.collectionViewContainer.frame.height / 2
                let nextValue = self.topConstraintContainerView.constant + moveValue

                if nextValue < maxYValue {
                    self.topConstraintContainerView.constant += moveValue
                }
                if nextValue < lowestYValue {
                    self.animateContainerViewDown()
                }
                if nextValue < 0 {
                    self.animateContainerViewDown()
                }
            }
        }
    }

    // MARK - Annotation Functions

    @objc private func addPinToMap(gesture: UILongPressGestureRecognizer) {
        if !isAnnotationAdded {
            isAnnotationAdded = true

            let touchPoint = gesture.location(in: mapView)
            var newCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            viewModel.set(newCoordinates)

            let annotation = MKPointAnnotation()
            annotation.coordinate = newCoordinates
            mapView.addAnnotation(annotation)

            newCoordinates.latitude -= mapView.region.span.latitudeDelta * 0.4
            mapView.setCenter(newCoordinates, animated: true)

            animateContainerViewUp()
        }
    }

    // MARK: - ContainerView Handler

    private func animateContainerViewUp() {
        topConstraintContainerView.constant = self.collectionViewContainer.frame.height + view.safeAreaInsets.bottom
        safeAreaBackground.isHidden = false
        onSetNewCollectionButton.isHidden = false

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    private func animateContainerViewDown() {
        topConstraintContainerView.constant = 0
        safeAreaBackground.isHidden = true
        onSetNewCollectionButton.isHidden = true

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    private func resetContainerView() {
        topConstraintContainerView.constant = 0
    }

    @IBAction func onSetNewCollection(_ sender: Any) {
        collectionViewController.viewModel?.setNewCollection()
    }
}
