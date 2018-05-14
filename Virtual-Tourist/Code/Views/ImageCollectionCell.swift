//
//  ImageCollectionCell.swift
//  Virtual-Tourist
//
//  Created by Matthias Wagner on 09.05.18.
//  Copyright © 2018 Matthias Wagner. All rights reserved.
//

import UIKit
import AlamofireImage

class ImageCollectionCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!

    func configure(photo: Photo) {

        imageView.af_cancelImageRequest()
        imageView.image = nil

        if let image = photo.image {
            imageView.image =  UIImage(data: image)
        } else if let url = photo.url {
            imageView.af_setImage(withURL: url) { response in
                photo.image = response.data

                DataController.shared.saveContext()
            }
        }
    }
}
