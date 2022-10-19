//
//  Tab.swift
//  MobileBrowser
//
//  Created by Tatiana Ampilogova on 7/12/22.
//

import UIKit

class Tab {
    
    let id = UUID().uuidString
    let viewController: BrowserViewController
    
    init(viewController: BrowserViewController) {
        self.viewController = viewController
    }
    
    var title: String {
        return viewController.title ?? "Start Page"
    }
}
