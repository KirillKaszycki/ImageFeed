//
//  InagesListCell.swift
//  ImageFeed
//
//  Created by Кирилл Кашицкий on 30.03.2024.
//

import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    
    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImagesListCellDelegate?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
    
    @IBAction func likeButtonClicked(_ sender: Any) {
        delegate?.imagesListCellDidTapLike(self)
    }
}
