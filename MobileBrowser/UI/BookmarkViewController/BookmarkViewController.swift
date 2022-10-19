//
//  BookmarkViewController.swift
//  MobileBrowser
//
//  Created by Tatiana Ampilogova on 7/11/22.
//

import UIKit

protocol BookmarkViewControllerDelegate: AnyObject {
    func didSelectBookmark(_ item: Bookmark)
}

class BookmarkViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private lazy var tableView = UITableView(frame: view.frame, style: .plain)
    private var items = [Bookmark]()
    private let bookmarkService: BookmarkService
    
    weak var delegate: BookmarkViewControllerDelegate?
    
    init(bookmarkService: BookmarkService) {
        self.bookmarkService = bookmarkService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        loadBookmarks()
        setupNavigationBar()
        setupTableView()
    }
    
    private func setupNavigationBar() {
        self.title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .automatic
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeAction))
    }

    private func setupTableView() {
        tableView.register(BookmarkCell.self, forCellReuseIdentifier: "BookmarkCell")
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    private func loadBookmarks() {
        self.items = bookmarkService.fetchBookmarks()
    }
    
    //MARK: - UITableViewDataSourse
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookmarkCell", for: indexPath) as! BookmarkCell
        let item = items[indexPath.row]
        cell.configurable(item)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        delegate?.didSelectBookmark(item)
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (_, _, completionHandler) in
            tableView.beginUpdates()
            self.bookmarkService.removeBookmark(id: self.items[indexPath.row].id)
            self.items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            completionHandler(true)
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [delete])
        return swipeActions
    }
    
    @objc private func closeAction() {
        self.dismiss(animated: true, completion: nil)
    }
}
