//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Кирилл Кашицкий on 19.05.2024.
//

import UIKit

final class AlertPresenter {
    func presentAlert(on vc: UIViewController,  message: String, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(
            title: "Что-то пошло не так, попробуйте позже",
            message: message,
            preferredStyle: .alert
        )
        
        let alertAction = UIAlertAction(title: "Ок", style: .cancel) { _ in
            completion?()
        }
        
        alertController.addAction(alertAction)
        vc.present(alertController, animated: true, completion: nil)
    }
}
