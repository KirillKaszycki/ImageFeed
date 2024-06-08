//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Кирилл Кашицкий on 11.04.2024.
//

import UIKit

final class SingleImageViewController: UIViewController {


    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var imageView: UIImageView!

    var image = UIImage()
//    {
//        didSet {
//            guard isViewLoaded, let image else { return }
//
//            imageView.image = image
//            imageView.frame.size = image.size
//            rescaleAndCenterImageInScrollView(image: image)
//        }
//    }
    var fullImageURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        setSingleImage()
    }

    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapShareButton(_ sender: UIButton) {
        // guard let image else { return }
        let share = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }
    
    private func centerImage() {
        let boundsSize = scrollView.bounds.size
        var frameToCenter = imageView.frame
    
        // Config horizontal
        if frameToCenter.size.width < boundsSize.width {
            frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2
        } else {
            frameToCenter.origin.x = 0
        }
        
        // COnfig vertical
        if frameToCenter.size.height < boundsSize.height {
            frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2
        } else {
            frameToCenter.origin.y = 0
        }
        
        imageView.frame = frameToCenter
    }
    
    private func updateMinZoomScaleForSize(_ size: CGSize) {
        let width = size.width / imageView.bounds.width
        let height = size.height / imageView.bounds.height
        let minScale = min(width, height)
        
        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = minScale
        scrollView.zoomScale = scrollView.minimumZoomScale
    }
}

// MARK: - Extension for UIScrollViewDelegate
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        centerImage()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateMinZoomScaleForSize(view.bounds.size)
    }
}

// MARK: - Extension for SingleImageViewController methods
extension SingleImageViewController {
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    private func setSingleImage() {
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: fullImageURL) { [weak self] res in
            UIBlockingProgressHUD.dismiss()
            
            guard let self = self else { return }
            switch res {
            case .success(let result):
                self.rescaleAndCenterImageInScrollView(image: result.image)
            case .failure:
                presentAlertSingleImage()
            }
        }
    }
    
    func presentAlertSingleImage() {
        let alertController = UIAlertController(
            title: "Что-то пошло не так. Попробовать ещё раз?",
            message: nil,
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "Повторить", style: .default) { [weak self] _ in
            self?.setSingleImage()
        })
        alertController.addAction(UIAlertAction(title: "Не повторять", style: .default) { [weak self] _ in
            self?.dismiss(animated: true)
        })
        present(alertController, animated: true)
    }
}
