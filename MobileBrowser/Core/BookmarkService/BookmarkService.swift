//
//  BookmarkService.swift
//  MobileBrowser
//
//  Created by Tatiana Ampilogova on 7/11/22.
//

import Foundation

protocol BookmarkService {
    func saveBookmark(url: URL, title: String)
    func fetchBookmarks() -> [Bookmark]
    func removeBookmark(id: String)
    func isContainsBookmark(url: URL) -> Bool
}

class BookmarkServiceIml: BookmarkService {

    private var bookmarks = [Bookmark]()
    
    func saveBookmark(url: URL, title: String) {
        bookmarks.append(Bookmark(id: UUID().uuidString, title: title, url: url))
    }
    
    func fetchBookmarks() -> [Bookmark] {
        return bookmarks
    }
    
    func isContainsBookmark(url: URL) -> Bool {
        for bookmark in bookmarks {
            if bookmark.url == url {
                return true
            }
        }
        return false
    }
    
    func removeBookmark(id: String) {
        for i in 0..<bookmarks.count {
            if bookmarks[i].id == id {
                bookmarks.remove(at: i)
                break
            }
        }
    }
}
