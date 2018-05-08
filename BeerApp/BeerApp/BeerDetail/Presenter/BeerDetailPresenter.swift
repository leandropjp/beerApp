//
//  BeerDetailPresenter.swift
//  BeerApp
//
//  Created by Leandro Paiva Andrade on 5/5/18.
//  Copyright © 2018 Leandro. All rights reserved.
//

import UIKit

class BeerDetailPresenter: BeerDetailViewToPresenterProtocol {
    
    var interactor: BeerDetailPresenterToInteractorProtocol?

    var view: BeerDetailPresenterToViewProtocol?
    
    var router: BeerDetailPresenterToRouterProtocol?
    
    var beer: Beer?
    
    func viewDidLoad() {
        if let beer = self.beer {
            view?.setupDetailView()
            view?.showBeerDetail(forBeer: beer)
        } else {
            view?.showError()
        }
    }
    
    func saveBeer() {
        guard let beer = self.beer else {
            return
        }
        do {
            print("Presenter - saving beer")
            try interactor?.saveBeer(beer: beer)
            //Show Success
        } catch {
            view?.showError()
        }
    }
    
    func deleteBeer() {
        guard let beer = self.beer else {
            return
        }
        print("Presenter - deleting beer")
        interactor?.deleteBeer(beer: beer)
    }
    
    func checkIfBeerIsFavorite() {
        guard let beer = self.beer else {
            return
        }
        interactor?.checkIfBeerIsFavorite(beerId: beer.id)
    }
    
}

extension BeerDetailPresenter: BeerDetailInteractorToPresenterProtocol {

    func onError() {
        view?.showError()
    }
    
    func prepareViewForFavoriteBeer() {
        view?.setupViewForFavoriteBeer()
    }

}
