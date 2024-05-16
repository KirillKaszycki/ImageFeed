//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Кирилл Кашицкий on 11.04.2024.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    private let profileService = ProfileService.shared
    
    private var profilePhoto = UIImage()
    private var nameLabel = UILabel()
    private var loginLabel = UILabel()
    private var descriptionLabel = UILabel()
    private var exitButton = UIButton()
    private let imageView = UIImageView(image: .avatar)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageConfigure()
        labelsConfigure()
        exitButtonConfigure()
        if let profile = profileService.profile {
            updateProfileDetails(profile: profile)
        }
    }
    
    // Profile Image
    private func profileImageConfigure() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    // Labels
    private func labelsConfigure() {
        // nameLabel.text = "Екатерина Новикова"
        nameLabel.text = "Name loading..."
        nameLabel.textColor = .ypWhite
        nameLabel.font = .systemFont(ofSize: 23, weight: .bold)
        
        // loginLabel.text = "@ekaterina_nov"
        loginLabel.text = "@username loading..."
        loginLabel.textColor = .ypGray
        loginLabel.font = .systemFont(ofSize: 13, weight: .regular)
        
        // descriptionLabel.text = "Hello, world!"
        descriptionLabel.text = "Bio loading..."
        descriptionLabel.textColor = .ypWhite
        descriptionLabel.font = .systemFont(ofSize: 13, weight: .regular)
        
        [nameLabel, loginLabel, descriptionLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        
        nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive = true
            
        loginLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        loginLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
            
        descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 8).isActive = true
    }
    
    // Quit Button
    private func exitButtonConfigure() {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "logout_button"), for: .normal)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        button.tintColor = .ypRed
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        button.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        
        button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
    }
    
    @objc
    private func didTapButton() {}
}

extension ProfileViewController {
//    private func loadProfileData() {
//        let tokenStorage = OAuth2TokenStorage()
//        
//        guard let token = tokenStorage.token else { return }
//        
//        ProfileService.shared.fetchProfile(token) { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success(let profile):
//                DispatchQueue.main.async {
//                    self.nameLabel.text = profile.name
//                    self.loginLabel.text = profile.loginName
//                    self.descriptionLabel.text = profile.bio
//                }
//            case .failure(let error):
//                print("Error fetching profile: \(error)")
//            }
//        }
//    }
    
    private func updateProfileDetails(profile: Profile) {
        self.nameLabel.text = profile.name
        self.loginLabel.text = profile.loginName
        self.descriptionLabel.text = profile.bio
    }
}
