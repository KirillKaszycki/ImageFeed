//
//  ImagesListViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Кирилл Кашицкий on 20.06.2024.
//

import Foundation

protocol ImagesListViewControllerProtocol: AnyObject {
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath)
}
