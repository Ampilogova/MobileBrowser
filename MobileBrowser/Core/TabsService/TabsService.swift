//
//  TabsService.swift
//  MobileBrowser
//
//  Created by Tatiana Ampilogova on 7/12/22.
//

import Foundation

protocol TabsService {
    
    func createTab() -> Tab
    
    func removeTab(id: String)
    
    func fetchTabs() -> [Tab]
}

class TabsServiceImpl: TabsService {

    private var tabs = [Tab]()
    private let bookmarkService: BookmarkService
    
    init(bookmarkService: BookmarkService) {
        self.bookmarkService = bookmarkService
    }
    
    func createTab() -> Tab {
        let tab = Tab(viewController: BrowserViewController(bookmarkService: bookmarkService))
        tabs.append(tab)
        
        return tab
    }
    
    func removeTab(id: String) {
        for i in 0..<tabs.count {
            if tabs[i].id == id {
                tabs.remove(at: i)
                break
            }
        }
    }

    func fetchTabs() -> [Tab] {
        return tabs
    }
}
