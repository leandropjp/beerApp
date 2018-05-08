//
//  BeerListRouter.swift
//  BeerApp
//
//  Created by Leandro Paiva Andrade on 5/4/18.
//  Copyright © 2018 Leandro. All rights reserved.
//

import UIKit

class BeerListRouter: BeerListPresenterToRouterProtocol {
    
    class func createBeerListModule() -> UIViewController {
        
        let view = BeerListView()
        let presenter: BeerListViewToPresentProtocol & BeerListInteractorToPresenterProtocol = BeerListPresenter()
        let interactor: BeerListPresenterToInteractorProtocol & BeerListDataManagerToInteractorProtocol = BeerListInteractor()
        let dataManager: BeerListInteractorToDataManagerProtocol = DataManager()
        let router: BeerListPresenterToRouterProtocol = BeerListRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        interactor.dataManager = dataManager
        dataManager.remoteRequestHandler = interactor
        
        let nav = UINavigationController(rootViewController: view)
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        nav.navigationBar.titleTextAttributes = textAttributes
        nav.navigationBar.barTintColor = ColorSource.primaryColor
        return nav

    }
    
    func presentBeerDetailScreen(from view: BeerListPresenterToViewProtocol, forBeer beer: Beer) {
        let beerDetailView = BeerDetailRouter.createBeerDetailModule(forBeer: beer)
        if let sourceView = view as? UIViewController {
            sourceView.navigationController?.pushViewController(beerDetailView, animated: true)
        }
    }
    
}
