//
//  BeerListProtocols.swift
//  BeerApp
//
//  Created by Leandro Paiva Andrade on 5/4/18.
//  Copyright © 2018 Leandro. All rights reserved.
//

import UIKit

protocol BeerListPresenterToViewProtocol: class {
    var presenter: BeerListViewToPresentProtocol? { get set }
    
    // PRESENTER -> VIEW
    func showBeers(beers: [Beer])
    func showQueriedBeers(beers: [Beer])
    func dismissSearchBar()
    func showError()
    func showLoading()
    func hideLoading()
    func setupView()
}

protocol BeerListPresenterToRouterProtocol: class {
    static func createBeerListModule() -> UIViewController
    // PRESENTER -> ROUTER
    func presentBeerDetailScreen(from view: BeerListPresenterToViewProtocol, forBeer beer: Beer)
}

protocol BeerListViewToPresentProtocol: class {
    var view: BeerListPresenterToViewProtocol? { get set }
    var interactor: BeerListPresenterToInteractorProtocol? { get set }
    var router: BeerListPresenterToRouterProtocol? { get set }
    
    // VIEW -> PRESENTER
    func viewDidLoad()
    func requestBeersFromQuery(query: String)
    func showBeerDetail(forBeer beer: Beer)
    func fetchLocalBeers()
    func fetchRemoteBeers()
    func searchForBeer(name: String)
}

protocol BeerListInteractorToPresenterProtocol: class {
    // INTERACTOR -> PRESENTER
    func didRetrieveQueriedBeers(_ beers: [Beer])
    func didRetrieveBeers(_ posts: [Beer])
    func onError()
}

protocol BeerListPresenterToInteractorProtocol: class {
    var presenter: BeerListInteractorToPresenterProtocol? { get set }
    var dataManager: BeerListInteractorToDataManagerProtocol? { get set }
    
    // PRESENTER -> INTERACTOR
    func retrieveBeerList()
    func retrieveLocalBeerList()
    func retrieveBeersFromQuery(query: String)
    func searchForBear(name: String)
}

protocol BeerListInteractorToDataManagerProtocol: class {
    var remoteRequestHandler: BeerListDataManagerToInteractorProtocol? { get set }
    // INTERACTOR -> REMOTEDATAMANAGER
    func retrieveBeerList()
    func retrieveBeersFromQuery(query: String)
    // INTERACTOR -> LOCALDATAMANAGER
    func retrieveLocalBeerList() throws -> [Beer]
}

protocol BeerListDataManagerToInteractorProtocol: class {
    // REMOTEDATAMANAGER -> INTERACTOR
    func onQueriedBeersRetrieved(_ beers: [Beer])
    func onBeersRetrieved(_ posts: [Beer])
    func onError()
}

