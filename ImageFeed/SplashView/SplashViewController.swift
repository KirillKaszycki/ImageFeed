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
    
    private let alertPresenter = AlertPresenter()
    
    private let logo: UIImageView = {
        let logo = UIImageView()
        logo.image = UIImage(named: "splach_screen_logo")
        logo.translatesAutoresizingMaskIntoConstraints = false
        return logo
    } ()
    
    //MARK: - Life cycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configSplashViewController()
        
        if let token = storage.token {
            fetchProfile(token)
        } else {
            switchToAuthViewController()
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    // MARK: Config the SplashViewCOntroller appearence
    private func configSplashViewController() {
        view.backgroundColor = .ypBlack
        
        // Logo position config
        self.view.addSubview(logo)
        NSLayoutConstraint.activate([
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logo.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    // MARK: Congig the navigation
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            fatalError("Invalid Configuration")
        }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
    
    private func switchToAuthViewController() {
        guard let authViewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "AuthViewController") as? AuthViewController
        else {
            fatalError("Invalid Configuration")
        }
        authViewController.delegate = self
        
        let navigationController = UINavigationController(rootViewController: authViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
}

//MARK: - Prepare
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

//MARK: - Fetch the principal data: token and profile info
extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) 
    }
    
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
    }
    
    private func fetchProfile(_ token: String){
        UIBlockingProgressHUD.show()
        profileService.fetchProfile(token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else { return }

            switch result {
            case .success(let profileResult):
                guard let username = profileResult.username else { return }
                profileImageService.fetchProfileImageURL(username: username) { _ in }
                self.switchToTabBarController()
            case .failure(let error):
                print("Parsing Data Error \(error.localizedDescription)")
                alertPresenter.presentAlert(on: self, message: "Не удалось получить данные профиля - \(error)")
            }
        }
    }

    private func fetchOAuthToken(_ code: String) {
        service.fetchOAuthToken(code: code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.switchToTabBarController()
            case .failure(let error):
                print("[SplashViewController] [fetchProfile] Error - \(error.localizedDescription)")
                alertPresenter.presentAlert(on: self, message: "Не удалось войти в систему - \(error)")
            }
        }
    }
}
