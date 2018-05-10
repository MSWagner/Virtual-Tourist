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

    func configure(url: URL) {

        imageView.af_cancelImageRequest()
        imageView.image = nil

        imageView.startAnimating()
        imageView.af_setImage(withURL: url) { [weak self] response in
            self?.imageView.stopAnimating()
        }
    }
}
