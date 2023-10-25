//
//  WebViewController.swift
//  FakeNFT
//
//  Created by Олег Аксененко on 13.10.2023.
//

import UIKit
import WebKit

protocol WebViewControllerOutput: AnyObject {
    func webViewDidLoad()
    func didTapBackButton()
}

protocol WebViewControllerInput: AnyObject {
    func startLoading()
}

final class WebViewController: UIViewController {
    private let startUrl: URL
    weak private var output: WebViewControllerOutput?
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false

        return webView
    }()

    init(with url: URL, output: WebViewControllerOutput?) {
        startUrl = url
        self.output = output

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
        view.backgroundColor = .ypWhite
        webView.backgroundColor = .ypWhite
        
        webView.navigationDelegate = self

        view.addSubview(webView)

        setupConstraints()
        setupNavBar()

        output?.webViewDidLoad()
    }
}

extension WebViewController: WebViewControllerInput {
    func startLoading() {
        webView.load(URLRequest(url: startUrl))
    }
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        UIBlockingProgressHUD.show()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIBlockingProgressHUD.dismiss()
    }
}

private extension WebViewController {
    func setupNavBar() {
        let leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "backButton"),
            style: .plain,
            target: self,
            action: #selector(didTapBackButton)
        )
        leftBarButtonItem.tintColor = .ypBlack
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    @objc func didTapBackButton() {
        output?.didTapBackButton()
    }
}
