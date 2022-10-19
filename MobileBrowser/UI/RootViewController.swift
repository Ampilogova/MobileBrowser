//
//  RootViewController.swift
//  MobileBrowser
//
//  Created by Tatiana Ampilogova on 7/12/22.
//

import UIKit

class RootViewController: UIViewController, BookmarkViewControllerDelegate, TabsViewControllerDelegate {
    
    private let toolBar = UIToolbar()
    private let bookmarkService: BookmarkService
    private let tabService: TabsService
    private let browserContainerViewController = UINavigationController()
    private var browserViewController: BrowserViewController?
    
    init(bookmarkService: BookmarkService, tabService: TabsService) {
        self.bookmarkService = bookmarkService
        self.tabService = tabService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        setupTab(tabService.createTab())
    }
    
    private func setupUI() {
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toolBar)
        NSLayoutConstraint.activate([
            toolBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            toolBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolBar.heightAnchor.constraint(equalToConstant: 64)
        ])
        
        browserContainerViewController.view.translatesAutoresizingMaskIntoConstraints = false // move
        add(browserContainerViewController)
        NSLayoutConstraint.activate([
            browserContainerViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            browserContainerViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            browserContainerViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            browserContainerViewController.view.bottomAnchor.constraint(equalTo: toolBar.topAnchor),
        ])
        
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let back = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButtonTapped))
        let reload = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"), style: .plain, target: self, action: #selector(reloadButtonTapped))
        let forward = UIBarButtonItem(image: UIImage(systemName: "chevron.forward"), style: .plain, target: self, action: #selector(forwardButtonTapped))
        let bookmark = UIBarButtonItem(image: UIImage(systemName: "book"), style: .plain, target: self, action: #selector(bookmarkTapped))
        let share = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(newTab))
        let tabs = UIBarButtonItem(image: UIImage(systemName: "square.on.square"), style: .plain, target: self, action: #selector(tapsTapped))
        
        self.toolBar.items = [back, space, forward, space, reload, space, share, space, bookmark, space, tabs]
    }
    
    func setupTab(_ tab: Tab) {
        browserViewController = tab.viewController
        browserContainerViewController.setViewControllers([tab.viewController], animated: false)
    }
    
    // MARK: - Actions
    
    @objc private func backButtonTapped(button: UIBarButtonItem) {
        browserViewController?.goBack()
    }
    
    @objc private func forwardButtonTapped(button: UIBarButtonItem) {
        browserViewController?.goForward()
    }
    
    @objc private func reloadButtonTapped(button: UIBarButtonItem) {
        browserViewController?.reload()
    }
    
    @objc private func newTab(button: UIBarButtonItem) {
        setupTab(tabService.createTab())
    }
    
    @objc private func bookmarkTapped(button: UIBarButtonItem) {
        let vc = BookmarkViewController(bookmarkService: bookmarkService)
        vc.delegate = self
        let nc = UINavigationController(rootViewController: vc)
        self.present(nc, animated: true)
    }
    
    @objc private func tapsTapped(button: UIBarButtonItem) {
        let vc = TabsViewController(tabsService: tabService)
        vc.delegate = self
        let nc = UINavigationController(rootViewController: vc)
        self.present(nc, animated: true)
    }
    
    func didSelectBookmark(_ item: Bookmark) {
        setupTab(tabService.createTab())
        browserViewController?.load(url: item.url)
    }
    
    func didSelectTab(_ item: Tab) {
        setupTab(item)
    }
}
