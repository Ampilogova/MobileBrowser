//
//  TabCell.swift
//  MobileBrowser
//
//  Created by Tatiana Ampilogova on 7/13/22.
//

import UIKit

class TabCell: UICollectionViewCell {
    
    var image: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "tab")
        return image
    }()
    
    var label: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    var button: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .gray
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        image.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(image)
        NSLayoutConstraint.activate([
            image.heightAnchor.constraint(equalToConstant: 100),
            image.widthAnchor.constraint(equalToConstant: 100),
            image.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            image.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        button.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(button)
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 20),
            button.widthAnchor.constraint(equalToConstant: 20),
            button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
        ])
        
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: 25),
            label.widthAnchor.constraint(equalToConstant: 100),
            label.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 5),
            label.leadingAnchor.constraint(equalTo: image.leadingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configurable(_ model: Tab) {
        self.label.text = model.title
    }
}
