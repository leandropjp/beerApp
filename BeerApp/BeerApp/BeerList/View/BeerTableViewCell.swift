//
//  BeerTableViewCell.swift
//  BeerApp
//
//  Created by Leandro Paiva Andrade on 5/4/18.
//  Copyright © 2018 Leandro. All rights reserved.
//

import UIKit

class BeerTableViewCell: UITableViewCell {
    
    private let beerImageView: LoadImageView = {
        let iv = LoadImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "placeholderImage")
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 2
        return label
    }()

    private let infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 2
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.backgroundColor = ColorSource.secondaryColor
        backgroundColor = ColorSource.secondaryColor
        accessoryType = .disclosureIndicator
        contentView.addSubview(beerImageView)
        beerImageView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 130, height: 150)
        let textStack = UIStackView(arrangedSubviews: [titleLabel, infoLabel])
        contentView.addSubview(textStack)
        textStack.translatesAutoresizingMaskIntoConstraints = false
        textStack.axis = .vertical
        textStack.spacing = 5
        textStack.centerYAnchor.constraint(equalTo: beerImageView.centerYAnchor).isActive = true
        textStack.leftAnchor.constraint(equalTo: beerImageView.rightAnchor, constant: 16).isActive = true
        textStack.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        beerImageView.image = #imageLiteral(resourceName: "placeholderImage")
    }
    
    func setupCell(beer: Beer) {
        titleLabel.text = beer.name
        infoLabel.text = beer.tagline
        beerImageView.loadImageWithLink(beer.imageUrl)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
