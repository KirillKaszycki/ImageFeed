//
//  ProfileViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Кирилл Кашицкий on 13.06.2024.
//

import UIKit

protocol ProfileViewControllerProtocol: AnyObject{
    var presenter: ProfileViewPeresenterProtocol? { get set }
    func updateAvatar(url: URL)
    func updateProfileDetails(profile: Profile)
}
