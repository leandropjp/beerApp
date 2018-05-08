//
//  BeerDetailView.swift
//  BeerApp
//
//  Created by Leandro Paiva Andrade on 5/5/18.
//  Copyright © 2018 Leandro. All rights reserved.
//

import UIKit

class BeerDetailView: UIViewController {
    var presenter: BeerDetailViewToPresenterProtocol?
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let beerImageView : LoadImageView = {
        let iv = LoadImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let beerNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    let beerDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = ColorSource.secondaryDarkColor
        label.numberOfLines = 0
        return label
    }()
    
    let favoriteButton : TopIconButton = {
        let btn = TopIconButton()
        btn.setImage(#imageLiteral(resourceName: "star").imageWithColor(color: .white)?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.backgroundColor = ColorSource.primaryColor
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        btn.setTitle("Add to favorites", for: .normal)
        btn.setTitle("Remove from favorites", for: .selected)
        btn.addTarget(self, action: #selector(btnTapped(sender:)), for: .touchUpInside)
        btn.sizeToFit()
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.checkIfBeerIsFavorite()
        presenter?.viewDidLoad()
    }
}

extension BeerDetailView: BeerDetailPresenterToViewProtocol {
    
    func setupViewForFavoriteBeer() {
        favoriteButton.isSelected = true
        favoriteButton.sizeToFit()
    }
    
    func setupDetailView() {
        navigationItem.title = "Beer Details"
        navigationController?.navigationBar.tintColor = .white
        view.addSubview(scrollView)
        view.backgroundColor = ColorSource.secondaryColor
        scrollView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        scrollView.addSubview(contentView)
        
        contentView.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, bottom: scrollView.bottomAnchor, right: scrollView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        contentView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        let contentHeight = contentView.heightAnchor.constraint(equalToConstant: 250)
        contentHeight.priority = UILayoutPriority.init(rawValue: 250)
        contentHeight.isActive = true

        let horizontalStack = UIStackView(arrangedSubviews: [beerImageView, beerNameLabel])
        horizontalStack.axis = .horizontal
        horizontalStack.spacing = 10
        beerImageView.widthAnchor.constraint(equalToConstant: 130).isActive = true
        horizontalStack.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        let descriptionView = UIView()
        descriptionView.addSubview(beerDescriptionLabel)
        beerDescriptionLabel.anchor(top: descriptionView.topAnchor, left: descriptionView.leftAnchor, bottom: descriptionView.bottomAnchor, right: descriptionView.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 16, paddingRight: 16, width: 0, height: 0)
        
        let verticalStack = UIStackView(arrangedSubviews: [horizontalStack, descriptionView])
        verticalStack.axis = .vertical
        
        contentView.addSubview(verticalStack)
        verticalStack.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

        contentView.addSubview(favoriteButton)
        favoriteButton.anchor(top: verticalStack.bottomAnchor, left: nil, bottom: contentView.bottomAnchor, right: nil, paddingTop: 16, paddingLeft: 0, paddingBottom: 16, paddingRight: 0, width: 0, height: 100)
        favoriteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        favoriteButton.layer.cornerRadius = 10
    }
    
    @objc func btnTapped(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        sender.sizeToFit()
        if sender.isSelected {
            print("View - saving beer")
            presenter?.saveBeer()
        } else {
            print("View - deleting beer")
            presenter?.deleteBeer()
        }
    }
    
    func showBeerDetail(forBeer beer: Beer) {
        beerImageView.loadImageWithLink(beer.imageUrl)
        
        let nameAttributtes:[NSAttributedStringKey: Any] = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 16),
                                                           NSAttributedStringKey.foregroundColor: UIColor.black]
        let attributedString = NSMutableAttributedString(string: beer.name, attributes: nameAttributtes)
        
        attributedString.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)]))
        
        let taglineAttributtes:[NSAttributedStringKey: Any] = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14),
                                                               NSAttributedStringKey.foregroundColor: ColorSource.secondaryDarkColor]
        attributedString.append(NSAttributedString(string: beer.tagline, attributes: taglineAttributtes))
        beerNameLabel.attributedText = attributedString
        
        beerDescriptionLabel.text = "\(beer.description)\n\nFood Pairing: \(beer.foodPairing.joined(separator: ", "))\n\nVolume: \(beer.volume.value) \(beer.volume.unit)"
    }
    
    func showError() {
        print("SHOW ERROR")
    }
}
