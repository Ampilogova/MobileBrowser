//
//  ViewController.swift
//  MobileBrowser
//
//  Created by Tatiana Ampilogova on 7/10/22.
//

import UIKit
import WebKit

class BrowserViewController: UIViewController, WKNavigationDelegate, UISearchBarDelegate {
    
    private let searchBar = UISearchBar()
    private var stringURL = "https://neeva.com/search"
    private let bookmarkService: BookmarkService
    
    init(bookmarkService: BookmarkService) {
        self.bookmarkService = bookmarkService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let webView: WKWebView = {
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences = preferences
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(webView)
        webView.allowsBackForwardNavigationGestures = true
        webView.navigationDelegate = self
        webView.addObserver(self, forKeyPath: "URL", options: .new, context: nil)
        setupSearchBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Search or enter address"
        searchBar.showsBookmarkButton = true
        searchBar.autocorrectionType = .no
        searchBar.autocapitalizationType = .none
        navigationItem.titleView = searchBar
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let key = change?[NSKeyValueChangeKey.newKey] {
            let stringURL = String(describing: key)
            searchBar.text = stringURL
        }
    }
    
    //MARK: - Actions
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text?.lowercased() else {
            return
        }
        if isValidUrl(url: searchText), let url = URL(string: searchText) {
            self.webView.load(URLRequest(url: url.sanitise))
        } else {
            let parameters = ["q": searchText]
            var urlComponents = URLComponents(string: stringURL)
            urlComponents?.queryItems = parameters.map({ URLQueryItem(name: $0, value: $1) })
            
            guard let url = urlComponents?.url else {
                return
            }
            self.webView.load(URLRequest(url: url))
        }
    }
    
    func load(url: URL) {
        self.webView.load(URLRequest(url: url))
    }
    
    func reload() {
        self.webView.reload()
    }
    
    func goForward() {
        if self.webView.canGoForward {
            self.webView.goForward()
        }
    }
    
    func goBack() {
        if self.webView.canGoBack {
            self.webView.goBack()
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.title = webView.title
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.showsCancelButton = false
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        guard let url = webView.url, let title = webView.title else {
            return
        }
        if !bookmarkService.isContainsBookmark(url: url) {
            bookmarkService.saveBookmark(url: url, title: title)
        }
    }
    
    func isValidUrl(url: String) -> Bool {
        let urlRegEx = "^(https?://)?(www\\.)?([-a-z0-9]{1,63}\\.)*?[a-z0-9][-a-z0-9]{0,61}[a-z0-9]\\.[a-z]{2,6}(/[-\\w@\\+\\.~#\\?&/=%]*)?$"
        let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
        let result = urlTest.evaluate(with: url)
        return result
    }
}

