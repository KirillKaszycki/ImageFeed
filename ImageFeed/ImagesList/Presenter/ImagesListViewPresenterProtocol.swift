//
//  ImagesListViewPresenterProtocol.swift
//  ImageFeed
//
//  Created by Кирилл Кашицкий on 20.06.2024.
//

import UIKit

protocol ImagesListViewPresenterProtocol: AnyObject {
    var view: ImagesListViewControllerProtocol? { get set }
    
    func viewDidLoad()
    func updateTableViewAnimated()
    func imageServiceObserverConfig()
    func removeObserver()
}
