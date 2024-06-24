//
//  WebViewPresenterProtocol.swift
//  ImageFeed
//
//  Created by Кирилл Кашицкий on 13.06.2024.
//

import Foundation

public protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    func viewDidLoad()
    func didUpdateProgressValue(_ newvalue: Double)
    func code(from url: URL) -> String?
}
