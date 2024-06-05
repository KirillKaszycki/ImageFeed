//
//  ImagesListCellDelegate.swift
//  ImageFeed
//
//  Created by Кирилл Кашицкий on 03.06.2024.
//

import UIKit

protocol ImagesListCellDelegate: AnyObject {
    func imagesListCellDidTapLike(_ cell: ImagesListCell)
}
