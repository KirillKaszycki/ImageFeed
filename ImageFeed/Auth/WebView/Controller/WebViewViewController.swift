//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Кирилл Кашицкий on 28.04.2024.
//

import UIKit
import WebKit

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code:String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

final class WebViewViewController: UIViewController & WebViewViewControllerProtocol {
    
    @IBOutlet private var webView: WKWebView!
    @IBOutlet private var progressView: UIProgressView!
    
    var presenter: WebViewPresenterProtocol?
    
    weak var delegate: WebViewViewControllerDelegate?
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        webView.navigationDelegate = self
        estimagerProgressObservationConfig()
    }
    
    //MARK: WebViewViewCOntroller methods
    @IBAction func didTapBackButton(_ sender: Any) {
        delegate?.webViewViewControllerDidCancel(self)
    }
    
    private func estimagerProgressObservationConfig() {
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [weak self] _, _ in
                 guard let self = self else { return }
                 self.presenter?.didUpdateProgressValue(self.webView.estimatedProgress)
             })
    }
    
    func setProgressValue(_ newValue: Float) {
        progressView.progress = newValue
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
    }
}

//MARK: - Load Auth View Extension
extension WebViewViewController {
    func load(request: URLRequest) {
        webView.load(request)
    }
}

//MARK: - Extension For WKNavigate Delegate
extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url {
            return presenter?.code(from: url)
        }
        return nil
    }
}
