//
//  BeerDetailInteractor.swift
//  BeerApp
//
//  Created by Leandro Paiva Andrade on 5/6/18.
//  Copyright © 2018 Leandro. All rights reserved.
//

import Foundation

class BeerDetailInteractor: BeerDetailPresenterToInteractorProtocol {

    var presenter: BeerDetailInteractorToPresenterProtocol?
    
    var dataManager: BeerDetailInteractorToDataManagerProtocol?
        
    func saveBeer(beer: Beer) throws {
        print("Interactor - saving beer")
        do {
            try dataManager?.saveBeer(beer: beer)
        } catch {
            throw PersistenceError.couldNotSaveObject
        }
        
    }
    
    func deleteBeer(beer: Beer) {
        print("Interactor - deleting beer")
        dataManager?.deleteBeer(beer: beer)

    }
    
    func checkIfBeerIsFavorite(beerId: Int) {
        dataManager?.checkIfBeerIsFavorite(beerId: beerId)
    }

}

extension BeerDetailInteractor: BeerDetailDataManagerToInteractorProtocol {
    
    func onFetchSuccess() {
        presenter?.prepareViewForFavoriteBeer()
    }
    
    func onError() {
        presenter?.onError()
    }
    
}
