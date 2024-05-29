//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Кирилл Кашицкий on 24.05.2024.
//

import UIKit

final class ImagesListService {
    
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    
    private var task: URLSessionTask?
    private let token = OAuth2TokenStorage()
    
    static let didChangeNotification = Notification.Name("ImagesListServiceDidChange")
    
    static let shared = ImagesListService()
    private init() {}
    
    // MARK: Fetching the photo data
    // Making a photo request
    private func makePhotoRequest(page: Int) -> URLRequest? {
        
        guard let imageURL = URL(string: "\(ImageListConstants.imageURLParser)\(page)") else {
            return nil
        }
        
        var request = URLRequest(url: imageURL)
        guard let token = token.token else { return nil }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        return request
    }
    
    // Configure the photo
    private func configurePhoto(from photo: PhotoResults) -> Photo? {
        guard let thumbImageURL = URL(string: photo.urls.thumb) else { return nil }
        guard let fullImageURL = URL(string: photo.urls.full) else { return nil }
        guard let date = photo.createdAt else { return nil }
        
        // format the date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let dateToFormat = dateFormatter.date(from: date) else { return nil }
        let formattedDate = dateFormatter.string(from: dateToFormat)
        
        return Photo(
            id: photo.id,
            size: CGSize(width: photo.width, height: photo.height),
            createdAt: formattedDate,
            welcomeDescription: photo.description,
            thumbImageURL: thumbImageURL,
            largeImageURL: fullImageURL,
            isLiked: photo.likedByUser
        )
    }
    
    // Fetching the photo's next page
    func fetchPhotosNextPage() {
//        assert(Thread.isMainThread)
//        task?.cancel()
        
        guard task != nil else { return }
    
        let nextPage = (lastLoadedPage ?? 0) + 1
        guard let request = makePhotoRequest(page: nextPage) else { return }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<PhotoResultList, Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let res):
//                if let photo = self.configurePhoto(from: res) {
//                    self.photos.append(photo)
//                    lastLoadedPage = nextPage
//                    NotificationCenter.default.post(
//                        name: Self.didChangeNotification,
//                        object: nil
//                    )
//                }
                
                self.photos.append(contentsOf: res.compactMap(self.configurePhoto))
                lastLoadedPage = nextPage
                NotificationCenter.default.post(
                    name: Self.didChangeNotification,
                    object: nil
                )
                print("Photos successfully fetched")
            case .failure(let error):
                print("[ImagesListSetvice][FetchPhotosNextPage] - \(error.localizedDescription)")
            }
            self.task = nil
        }
        self.task = task
    }
}
