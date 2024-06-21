//
//  ViewController.swift
//  ImageFeed
//
//  Created by Кирилл Кашицкий on 28.03.2024.
//

import UIKit

final class ImagesListViewController: UIViewController, ImagesListViewControllerProtocol {

    @IBOutlet var tableView: UITableView!

    private let photosName: [String] = Array(0..<20).map{ "\($0)" }

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    //private var photos: [Photo] = []
    let imagesListService = ImagesListService.shared
    var imagesListServiceObserver: NSObjectProtocol?
    
    var presenter: ImagesListViewPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 200
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        presenter = ImagesListViewPresenter(view: self)
        presenter?.viewDidLoad()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            
            let image = presenter?.photos[indexPath.row].fullImageURL
            viewController.fullImageURL = image
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func updateTableViewAnimated(oldCount: Int, newCount: Int) {
        guard oldCount != newCount else { return }
        tableView.performBatchUpdates {
            let indexPaths = (oldCount..<newCount).map { IndexPath(row: $0, section: 0) }
            tableView.insertRows(at: indexPaths, with: .automatic)
        }
    }
    
//    //MVP
//    func updateTableViewAnimated() {
//        let oldCount = photos.count
//        let newCount = imagesListService.photos.count
//        
//        photos = imagesListService.photos
//        if oldCount != newCount {
//            tableView.performBatchUpdates {
//                let indexPaths = (oldCount..<newCount).map { i in
//                    IndexPath(row: i, section: 0)
//                }
//                tableView.insertRows(at: indexPaths, with: .automatic)
//            } completion: { _ in }
//        }
//    }
    
    
//    //MVP
//    private func imageServiceObserverConfig() {
//        imagesListServiceObserver = NotificationCenter.default.addObserver(
//            forName: ImagesListService.didChangeNotification,
//            object: nil,
//            queue: .main) { [weak self] _ in
//                guard let self = self else { return }
//                updateTableViewAnimated()
//            }
//    }
    
}

// MARK: - Extension for UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.photos.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)

        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }

        imageListCell.delegate = self
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
}

// MARK: - Extension for UITableViewDataSource
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row + 1 == presenter?.photos.count else { return }
        imagesListService.fetchPhotosNextPage()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = presenter?.photos[indexPath.row] else { return 0}
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}

// MARK: - Extension for ImagesListViewController methods
extension ImagesListViewController {
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        
        guard let image = presenter?.photos[indexPath.row] else { return }
        cell.cellImage.kf.setImage(
            with: image.fullImageURL,
            placeholder: UIImage(named: "placeholderImage")) { [weak self] _ in
                guard let self = self else { return }
                self.tableView.reloadRows(
                    at: [indexPath],
                    with: .automatic)
            }
        
        cell.cellImage.kf.indicatorType = .activity
        cell.dateLabel.text = image.createdAt
    }
}

// MARK: - Extension for ImagesListCellDelegate
extension ImagesListViewController: ImagesListCellDelegate {
    func imagesListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        guard let photo = presenter?.photos[indexPath.row] else { return }
        
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoID: photo.id, isLike: photo.isLiked) { [weak self] res in
            guard let self = self else { return }
            
            switch res {
            case .success:
                self.presenter?.photos = self.imagesListService.photos
                if let isLiked = self.presenter?.photos[indexPath.row].isLiked {
                    cell.visualizeTheLike(isLiked: isLiked)
                }
                print("[ImagesListViewController][imagesListCellDidTapLike] - Like successfully changed")
                UIBlockingProgressHUD.dismiss()
            case .failure(let error):
                print("[ImagesListViewController][imagesListCellDidTapLike] - \(error.localizedDescription)")
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
}
