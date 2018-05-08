//
//  BeerDetailProtocols.swift
//  BeerApp
//
//  Created by Leandro Paiva Andrade on 5/5/18.
//  Copyright © 2018 Leandro. All rights reserved.
//

import UIKit

protocol BeerDetailPresenterToViewProtocol: class {
    var presenter: BeerDetailViewToPresenterProtocol? { get set }
    
    // PRESENTER -> VIEW
    func showBeerDetail(forBeer beer: Beer)
    func showError()
    func setupDetailView()
    func setupViewForFavoriteBeer()
}

protocol BeerDetailPresenterToRouterProtocol: class {
    static func createBeerDetailModule(forBeer beer: Beer) -> UIViewController
}

protocol BeerDetailViewToPresenterProtocol: class {
    var view: BeerDetailPresenterToViewProtocol? { get set }
    var router: BeerDetailPresenterToRouterProtocol? { get set }
    var interactor: BeerDetailPresenterToInteractorProtocol? { get set }
    var beer: Beer? { get set }
    
    // VIEW -> PRESENTER
    func viewDidLoad()
    func saveBeer()
    func deleteBeer()
    func checkIfBeerIsFavorite()
}

protocol BeerDetailPresenterToInteractorProtocol: class {
    var presenter: BeerDetailInteractorToPresenterProtocol? { get set }
    var dataManager: BeerDetailInteractorToDataManagerProtocol? { get set }
    
    // PRESENTER -> INTERACTOR
    func saveBeer(beer: Beer) throws
    func deleteBeer(beer: Beer)
    func checkIfBeerIsFavorite(beerId: Int)
}

protocol BeerDetailInteractorToDataManagerProtocol: class {
    var localRequestHandler: BeerDetailDataManagerToInteractorProtocol? { get set }
    // INTERACTOR -> LOCALDATAMANAGER
    func saveBeer(beer: Beer) throws
    func deleteBeer(beer: Beer)
    func checkIfBeerIsFavorite(beerId: Int)
}

protocol BeerDetailInteractorToPresenterProtocol: class {
    // INTERACTOR -> PRESENTER
    func onError()
    func prepareViewForFavoriteBeer()
}

protocol BeerDetailDataManagerToInteractorProtocol: class {
    // REMOTEDATAMANAGER -> INTERACTOR
    func onFetchSuccess()
    func onError()
}
