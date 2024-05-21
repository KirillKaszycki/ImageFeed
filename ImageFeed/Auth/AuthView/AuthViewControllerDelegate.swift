//
//  AuthViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Кирилл Кашицкий on 19.05.2024.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}
