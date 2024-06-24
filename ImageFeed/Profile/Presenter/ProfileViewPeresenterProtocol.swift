//
//  ProfileViewPeresenterProtocol.swift
//  ImageFeed
//
//  Created by Кирилл Кашицкий on 13.06.2024.
//

import Foundation

protocol ProfileViewPeresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func updateAvatar()
    func updateProfileDetails()
    func profileImageServiceObserverSetting()
    func profileImageServiceRemoveObserver()
    func logout()
}
