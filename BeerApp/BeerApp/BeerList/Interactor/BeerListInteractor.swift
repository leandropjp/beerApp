//
//  BeerListInteractor.swift
//  BeerApp
//
//  Created by Leandro Paiva Andrade on 5/4/18.
//  Copyright © 2018 Leandro. All rights reserved.
//

class BeerListInteractor: BeerListPresenterToInteractorProtocol {
    
    weak var presenter: BeerListInteractorToPresenterProtocol?
    var dataManager: BeerListInteractorToDataManagerProtocol?
    
    func retrieveBeerList() {
        dataManager?.retrieveBeerList()
    }
    
    func retrieveLocalBeerList() {
        do {
            if let beerList = try dataManager?.retrieveLocalBeerList() {
                presenter?.didRetrieveBeers(beerList)
            } else {
                 presenter?.didRetrieveBeers([])
            }
        } catch {
            presenter?.didRetrieveBeers([])
        }
    }
    
    func searchForBear(name: String) {
        do {
            if let beerList = try dataManager?.retrieveLocalBeerList() {
                let list = beerList.filter { return $0.name.range(of: name) != nil }

                presenter?.didRetrieveQueriedBeers(list)
            } else {
                presenter?.didRetrieveBeers([])
            }
            
        } catch {
            presenter?.didRetrieveBeers([])
        }
    }
    
    func retrieveBeersFromQuery(query: String) {
        dataManager?.retrieveBeersFromQuery(query: query)
    }
    
}

extension BeerListInteractor: BeerListDataManagerToInteractorProtocol {
    
    func onQueriedBeersRetrieved(_ beers: [Beer]) {
        presenter?.didRetrieveQueriedBeers(beers)
    }
    
    
    func onBeersRetrieved(_ posts: [Beer]) {
        presenter?.didRetrieveBeers(posts)
    }
    
    func onError() {
        presenter?.onError()
    }
    
}
