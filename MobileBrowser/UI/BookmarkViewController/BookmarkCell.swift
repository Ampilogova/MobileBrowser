//
//  BookmarkCell.swift
//  MobileBrowser
//
//  Created by Tatiana Ampilogova on 7/11/22.
//

import Foundation
import UIKit

class BookmarkCell: UITableViewCell {
    
    var titleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configurable(_ model: Bookmark) {
        self.titleLabel.text = model.title
    }
    override func prepareForReuse() {
        titleLabel.text = nil
    }
}
