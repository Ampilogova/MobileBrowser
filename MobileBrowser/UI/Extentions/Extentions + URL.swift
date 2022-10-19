//
//  Extentions + URL.swift
//  MobileBrowser
//
//  Created by Tatiana Ampilogova on 7/15/22.
//

import UIKit

public extension URL {
    var sanitise: URL {
        if var components = URLComponents(url: self, resolvingAgainstBaseURL: false) {
            if components.scheme == nil {
                components.scheme = "http"
            }
            
            return components.url ?? self
        }
        return self
    }
}
