//
//  ImagesListViewPresenter.swift
//  ImageFeed
//
//  Created by Кирилл Кашицкий on 20.06.2024.
//

import UIKit

final class ImagesListViewPresenter: ImagesListViewPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    
    private(set) var photos: [Photo] = []
    private let imagesListService = ImagesListService.shared
    private var imagesListServiceObserver: NSObjectProtocol?
    
    init(view: ImagesListViewControllerProtocol) {
        self.view = view
    }
    
    func viewDidLoad(tableView: UITableView) {
        imagesListService.fetchPhotosNextPage()
        imageServiceObserverConfig(tableView: tableView)
    }
    
    func updateTableViewAnimated(tableView: UITableView) {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        
        photos = imagesListService.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
    
    func imageServiceObserverConfig(tableView: UITableView) {
        imagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            updateTableViewAnimated(tableView: tableView)
        }
    }
    
    func removeObserver() {
        if let observer = imagesListServiceObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}
