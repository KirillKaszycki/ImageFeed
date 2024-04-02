//
//  InagesListCell.swift
//  ImageFeed
//
//  Created by Кирилл Кашицкий on 30.03.2024.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
}
