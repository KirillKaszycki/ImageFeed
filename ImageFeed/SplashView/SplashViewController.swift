//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Кирилл Кашицкий on 30.04.2024.
//

import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    private let ShowAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let storage = OAuth2TokenStorage()
    private let service = OAuth2Service.shared
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let token = storage.token {
            fetchProfile(token)
            switchToTabBarController()
        } else {
            // Show Auth Screen
            performSegue(withIdentifier: ShowAuthenticationScreenSegueIdentifier, sender: nil)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
}

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowAuthenticationScreenSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else { fatalError("Failed to prepare for \(ShowAuthenticationScreenSegueIdentifier)") }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) 
    }
    
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        
//        guard let token = storage.token else { return }
//        fetchProfile(token)
    }
    
    private func fetchProfile(_ token: String){
        UIBlockingProgressHUD.show()
        profileService.fetchProfile(token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else { return }

            switch result {
            case .success:
                self.switchToTabBarController()
            case .failure(let error):
                // 11
                print("Parsing Data Error \(error)")
                break
            }
        }
    }

    private func fetchOAuthToken(_ code: String) {
        service.fetchOAuthToken(code: code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.switchToTabBarController()
            case .failure:
                // 11
                print("Cannot switch to TabBarVC")
                break
            }
        }
    }
}
