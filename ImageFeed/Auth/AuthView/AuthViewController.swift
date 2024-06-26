//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Кирилл Кашицкий on 28.04.2024.
//

import UIKit
import ProgressHUD

final class AuthViewController: UIViewController {
    
    
    weak var delegate: AuthViewControllerDelegate?
    private let showWebViewSegueIdentifier = "ShowWebView"
    private let apertPresenter = AlertPresenter()
    var authHelper = AuthHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBackButton()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else {
                fatalError("Failed to prepare for \(showWebViewSegueIdentifier)")
            }
            let webWiewPresenter = WebViewPresenter(authHelper: authHelper)
            webViewViewController.presenter = webWiewPresenter
            webWiewPresenter.view = webViewViewController
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

//MARK: - Back Button Configuration
extension AuthViewController {
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "nav_back_button")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "nav_back_button")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "",
                                                           style: .plain,
                                                           target: nil,
                                                           action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "YPBlack")
    }
}

//MARK: - Extension for WebViewViewController Delegate
extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true)
        UIBlockingProgressHUD.show()
        
        OAuth2Service.shared.fetchOAuthToken(code: code) { [weak self] result in
            
            guard let self = self else { return }
            UIBlockingProgressHUD.dismiss()
            
             switch result {
             case .success(let token):
                 self.delegate?.authViewController(self, didAuthenticateWithCode: code)
                 print("Successfully fetched OAuth token:", token)
             case .failure(let error):
                 print("Failed to fetch OAuth token:", error)
             }
         }
     }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
