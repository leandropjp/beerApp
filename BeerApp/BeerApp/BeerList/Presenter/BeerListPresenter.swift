//
//  BeerListPresenter.swift
//  BeerApp
//
//  Created by Leandro Paiva Andrade on 5/4/18.
//  Copyright © 2018 Leandro. All rights reserved.
//

class BeerListPresenter: BeerListViewToPresentProtocol {

    weak var view: BeerListPresenterToViewProtocol?
    var interactor: BeerListPresenterToInteractorProtocol?
    var router: BeerListPresenterToRouterProtocol?
    
    func viewDidLoad() {
        view?.showLoading()
        view?.setupView()
        interactor?.retrieveBeerList()
    }
    
    func searchForBeer(name: String) {
        interactor?.searchForBear(name: name)
    }
    
    func fetchRemoteBeers() {
        view?.showLoading()
        interactor?.retrieveBeerList()
    }
    
    func requestBeersFromQuery(query: String) {
        interactor?.retrieveBeersFromQuery(query: query)
    }
    
    func showBeerDetail(forBeer beer: Beer) {
        guard let view = self.view else {
            return
        }
        router?.presentBeerDetailScreen(from: view, forBeer: beer)
    }
    
    func fetchLocalBeers() {
        view?.showLoading()
        interactor?.retrieveLocalBeerList()
    }
    
}

extension BeerListPresenter: BeerListInteractorToPresenterProtocol {
    
    func didRetrieveQueriedBeers(_ beers: [Beer]) {
        view?.hideLoading()
        view?.showQueriedBeers(beers: beers)
    }
    
    func didRetrieveBeers(_ beers: [Beer]) {
        view?.hideLoading()
        view?.showBeers(beers: beers)
    }
    
    func onError() {
        view?.hideLoading()
        view?.showError()
    }
    
}

