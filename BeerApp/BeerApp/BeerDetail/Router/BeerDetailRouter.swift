//
//  BeerDetailRouter.swift
//  BeerApp
//
//  Created by Leandro Paiva Andrade on 5/5/18.
//  Copyright © 2018 Leandro. All rights reserved.
//

import UIKit

class BeerDetailRouter: BeerDetailPresenterToRouterProtocol {
    
    static func createBeerDetailModule(forBeer beer: Beer) -> UIViewController {
        let view = BeerDetailView()
        let presenter: BeerDetailViewToPresenterProtocol & BeerDetailInteractorToPresenterProtocol = BeerDetailPresenter()
        let router: BeerDetailPresenterToRouterProtocol = BeerDetailRouter()
        let interactor: BeerDetailPresenterToInteractorProtocol & BeerDetailDataManagerToInteractorProtocol = BeerDetailInteractor()
        let dataManager: BeerDetailInteractorToDataManagerProtocol = DataManager()
        
        view.presenter = presenter
        presenter.view = view
        presenter.beer = beer
        presenter.router = router
        presenter.interactor = interactor
        interactor.dataManager = dataManager
        interactor.presenter = presenter
        dataManager.localRequestHandler = interactor
        
        return view
    }
    
}
