//
//  CollectionViewController.swift
//  Virtual-Tourist
//
//  Created by Matthias Wagner on 09.05.18.
//  Copyright © 2018 Matthias Wagner. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class CollectionViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet weak var dragControl: DragControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

    // MARK: - Properties

    let cellIdentifier = "ImageCollectionCell"

    var viewModel: PhotoCollectionViewModel? {
        didSet {
            if let viewModel = viewModel {
                viewModel.photos.producer.startWithValues { [weak self] _ in
                    print("Reload CollectionView")
                    self?.collectionView.reloadData()
                }
            }
        }
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)

        flowLayout.itemSize = CGSize(width: collectionView.bounds.width / 3 - 1, height: collectionView.bounds.width / 3 - 1)
        flowLayout.minimumLineSpacing = 1
    }
}

// MARK: - UICollectionViewDataSource

extension CollectionViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let photos = viewModel?.photos.value {
            return photos.count
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ImageCollectionCell

        if let viewModel = viewModel {
            cell.configure(photo: viewModel.photos.value[indexPath.row])
        }

        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension CollectionViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel?.deletePhotoWith(indexPath)
    }
}
