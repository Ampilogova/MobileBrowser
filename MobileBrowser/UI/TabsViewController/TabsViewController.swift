//
//  TabsViewController.swift
//  MobileBrowser
//
//  Created by Tatiana Ampilogova on 7/13/22.
//

import UIKit

protocol TabsViewControllerDelegate: AnyObject {
    func didSelectTab(_ item: Tab)
}

class TabsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private var tabs = [Tab]()
    private var tabsService: TabsService
    weak var delegate: TabsViewControllerDelegate?
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    
    init(tabsService: TabsService) {
        self.tabsService = tabsService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setUpCollectionView()
        loadTabs()
    }
    
    private func loadTabs() {
        tabs = tabsService.fetchTabs()
    }
    
    private func setupNavigationBar() {
        self.title = "Tabs"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .automatic
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeAction))
    }
    
    private func setUpCollectionView() {
        collectionView.register(TabCell.self, forCellWithReuseIdentifier: "TabCell")
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10,
                                           left: 10,
                                           bottom: 10,
                                           right: 10)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: 120, height: 120)
        
        return layout
    }
    
    // MARK: - UICollectionViewDataSourse
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TabCell", for: indexPath) as! TabCell
        let model = tabs[indexPath.row]
        cell.button.tag = indexPath.row
        cell.button.addTarget(self, action: #selector(deleteTab), for: .touchUpInside)
        cell.configurable(model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = tabs[indexPath.row]
        delegate?.didSelectTab(item)
        dismiss(animated: true)
    }
    
    @objc private func closeAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func deleteTab(sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        tabsService.removeTab(id: tabs[indexPath.row].id)
        collectionView.performBatchUpdates {
            tabs.remove(at: indexPath.row)
            collectionView.deleteItems(at: [indexPath])
        } completion: { isCompleated in
            self.collectionView.reloadData()
        }
    }
}
