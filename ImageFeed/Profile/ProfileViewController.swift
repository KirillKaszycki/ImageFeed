//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Кирилл Кашицкий on 11.04.2024.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    private var profilePhoto = UIImage()
    private var nameLabel = UILabel()
    private var loginLabel = UILabel()
    private var descriptionLabel = UILabel()
    private var exitButton = UIButton()
    private let imageView: UIImageView = {
        let avatar = UIImageView()
        avatar.image = UIImage(named: "avatar")
        avatar.layer.cornerRadius = 35 // As a default the picture is squared
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.clipsToBounds = true
        return avatar
    }()
    
    private var profileImageServiceObserver: NSObjectProtocol?

    // I'll remove it later. Now I preservet it for potential debug
//    override init(nibName: String?, bundle: Bundle?) {
//         super.init(nibName: nibName, bundle: bundle)
//         addObserver()
//     }
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        addObserver()
//    }
//    
//    deinit {
//        removeObserver()
//    }
//    
//    private func addObserver() {
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(updateAvatar(notification:)),
//            name: ProfileImageService.didChangeNotofication,
//            object: nil)
//    }
//    
//    private func removeObserver() {
//        NotificationCenter.default.removeObserver(
//            self,
//            name: ProfileImageService.didChangeNotofication,
//            object: nil)
//    }
//    
//    @objc
//    private func updateAvatar(notification: Notification) {
//        guard
//            isViewLoaded,
//            let userInfo = notification.userInfo,
//            let profileImageURL = userInfo["URL"] as? String,
//            let url = URL(string: profileImageURL)
//        else { return }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageConfigure()
        labelsConfigure()
        exitButtonConfigure()
        if let profile = profileService.profile {
            updateProfileDetails(profile: profile)
        }
        configUpdateAvatarForVDL()
    }
    
    // Profile Image
    private func updateAvatar() {
        guard
            let profileImageURL = profileImageService.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        imageView.kf.setImage(with: url)
    }
    
    private func configUpdateAvatarForVDL() {
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotofication,
            object: nil,
            queue: .main) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        updateAvatar()
    }
    
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
    private func updateProfileDetails(profile: Profile) {
        self.nameLabel.text = profile.name
        self.loginLabel.text = profile.login_name
        self.descriptionLabel.text = profile.bio
    }
}

extension ProfileViewController {
   
}
