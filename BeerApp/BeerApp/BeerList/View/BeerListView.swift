//
//  BeerListView.swift
//  BeerApp
//
//  Created by Leandro Paiva Andrade on 5/4/18.
//  Copyright © 2018 Leandro. All rights reserved.
//

import UIKit

class BeerListView: UIViewController {
    
    let cellId = "cellId"
    let tableView = UITableView()
    var presenter: BeerListViewToPresentProtocol?
    let mySearchBar = UISearchBar()
    var beerList = [Beer]()
    var filteredList = [Beer]()
    var isSearchBarActive = false
    let listButton = UIButton()
    let favoritesButton = UIButton()
    
    let loadingView: LoadingView = {
        let loading = LoadingView()
        loading.modalPresentationStyle = .custom
        loading.modalTransitionStyle = .crossDissolve
        loading.view.layer.speed = 1
        return loading
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if favoritesButton.isSelected {
            presenter?.fetchLocalBeers()
        }
    }
    
    @objc func selectedView(sender: UIButton) {
        if sender == listButton {
             navigationItem.title = "Beer List"
            listButton.isSelected = true
            favoritesButton.isSelected = false
            presenter?.fetchRemoteBeers()
        } else {
            navigationItem.title = "Favorites"
            listButton.isSelected = false
            favoritesButton.isSelected = true
            presenter?.fetchLocalBeers()
        }
    }        
}

extension BeerListView: BeerListPresenterToViewProtocol {
    
    func setupView() {
        edgesForExtendedLayout = []
        extendedLayoutIncludesOpaqueBars = false
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.layer.shadowColor = UIColor.clear.cgColor
        navigationController?.navigationBar.layer.shadowOpacity = 0
        navigationItem.title = "Beer List"
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        tableView.anchor(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 50, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(BeerTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.cellLayoutMarginsFollowReadableWidth = false
        mySearchBar.delegate = self
        mySearchBar.showsCancelButton = false
        mySearchBar.searchBarStyle = UISearchBarStyle.default
        mySearchBar.isTranslucent = false
        mySearchBar.barTintColor = ColorSource.primaryColor
        mySearchBar.backgroundImage = UIImage()
        mySearchBar.tintColor = UIColor.white
        mySearchBar.showsSearchResultsButton = false
        self.view.addSubview(mySearchBar)
        mySearchBar.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: tableView.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        tableView.backgroundColor = ColorSource.secondaryColor
        
        let textFieldInsideSearchBar = mySearchBar.value(forKey: "_searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .white
        
        textFieldInsideSearchBar?.backgroundColor = ColorSource.secondaryColor.withAlphaComponent(0.3)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributtes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.foregroundColor: UIColor.white,
                                                         NSAttributedStringKey.paragraphStyle: paragraphStyle]
        textFieldInsideSearchBar?.attributedPlaceholder = NSAttributedString(string: "Search",
                                                                             attributes: attributtes)
        
        if let glassIconView = textFieldInsideSearchBar?.leftView as? UIImageView {
            glassIconView.image = glassIconView.image?.withRenderingMode(.alwaysTemplate)
            glassIconView.tintColor = .white
        }
        
        let buttonsView = UIView()
        view.addSubview(buttonsView)
        buttonsView.backgroundColor = ColorSource.secondaryColor
        buttonsView.anchor(top: tableView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 49)
        
        listButton.imageView?.contentMode = .scaleAspectFit
        listButton.setImage(#imageLiteral(resourceName: "placeholderImage").withRenderingMode(.alwaysOriginal), for: .normal)
        listButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        listButton.setImage(#imageLiteral(resourceName: "beer").imageWithColor(color: ColorSource.secondaryDarkColor)?.withRenderingMode(.alwaysOriginal), for: .normal)
        listButton.setImage(#imageLiteral(resourceName: "beer").imageWithColor(color: ColorSource.primaryColor)?.withRenderingMode(.alwaysOriginal), for: .selected)
        listButton.addTarget(self, action: #selector(selectedView(sender:)), for: .touchUpInside)
        listButton.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        listButton.adjustsImageWhenHighlighted = false
        listButton.isSelected = true
        
        favoritesButton.adjustsImageWhenHighlighted = false
        favoritesButton.setImage(#imageLiteral(resourceName: "star").imageWithColor(color: ColorSource.secondaryDarkColor)?.withRenderingMode(.alwaysOriginal), for: .normal)
        favoritesButton.setImage(#imageLiteral(resourceName: "star").imageWithColor(color: ColorSource.primaryColor)?.withRenderingMode(.alwaysOriginal), for: .selected)
        favoritesButton.imageView?.contentMode = .scaleAspectFit
        favoritesButton.addTarget(self, action: #selector(selectedView(sender:)), for: .touchUpInside)
        favoritesButton.titleLabel?.font = UIFont.systemFont(ofSize: 8)
        favoritesButton.setTitleColor(ColorSource.primaryColor, for: .normal)
        favoritesButton.imageEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        favoritesButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        
        let buttonsStack = UIStackView(arrangedSubviews: [listButton, favoritesButton])
        buttonsStack.axis = .horizontal
        buttonsStack.spacing = 25
        buttonsView.addSubview(buttonsStack)
        buttonsStack.anchor(top: buttonsView.topAnchor, left: nil, bottom: buttonsView.bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 5, width: 0, height: 0)
        buttonsStack.centerXAnchor.constraint(equalTo: buttonsView.centerXAnchor).isActive = true
        
        let border = UIView()
        border.backgroundColor = ColorSource.secondaryDarkColor
        border.alpha = 0.3
        buttonsView.addSubview(border)
        border.anchor(top: buttonsView.topAnchor, left: buttonsView.leftAnchor, bottom: nil, right: buttonsView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
    }
    
    func dismissSearchBar() {
        mySearchBar.endEditing(true)
    }
    
    func showQueriedBeers(beers: [Beer]) {
        filteredList = beers
        tableView.reloadData()
    }
    
    func showBeers(beers: [Beer]) {
        beerList = beers
        tableView.reloadData()
    }
    
    func showError() {
        loadingView.setupErrorMessage()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.loadingView.dismiss(animated: true, completion: nil)
        }
        print("SHOW ERROR")
    }
    
    func showLoading() {
        DispatchQueue.main.async {
            self.loadingView.setupLoadingMessage()
            self.present(self.loadingView, animated: true, completion: nil)
        }
        print("SHOW LOADING")
    }
    
    func hideLoading() {
        DispatchQueue.main.async {
            self.loadingView.dismiss(animated: true)
        }
        print("HIDE LOADING")
    }

}

extension BeerListView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearchBarActive {
            return filteredList.count
        } else {
            return beerList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! BeerTableViewCell
        
        if isSearchBarActive {
            let beer = filteredList[indexPath.row]
            cell.setupCell(beer: beer)
            return cell
        } else {
            let beer = beerList[indexPath.row]
            cell.setupCell(beer: beer)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.showBeerDetail(forBeer: beerList[indexPath.row])
    }
    
}

extension BeerListView: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearchBarActive = true
        if favoritesButton.isSelected {
            presenter?.searchForBeer(name: searchText)
        } else {
            presenter?.requestBeersFromQuery(query: searchText)
        }
        
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        isSearchBarActive = false
        tableView.reloadData()
        return true
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        isSearchBarActive = true
        tableView.reloadData()
        return true
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
}
