//
//  DataManager.swift
//  BeerApp
//
//  Created by Leandro Paiva Andrade on 5/4/18.
//  Copyright © 2018 Leandro. All rights reserved.
//

import Foundation
import Alamofire
import CoreData

class DataManager: BeerListInteractorToDataManagerProtocol {    

    var remoteRequestHandler: BeerListDataManagerToInteractorProtocol?
    var localRequestHandler: BeerDetailDataManagerToInteractorProtocol?

    func retrieveBeersFromQuery(query: String) {
        Alamofire.request(APIRouter.getBeerWithName(name: query))
            .validate()
            .responseData { responseAlamoFire in
                switch responseAlamoFire.result {
                case .success:
                    if let data = responseAlamoFire.result.value {
                        do {
                            let decoder = JSONDecoder()
                            decoder.keyDecodingStrategy = .convertFromSnakeCase
                            let model = try decoder.decode([Beer].self, from: data)
                            self.remoteRequestHandler?.onQueriedBeersRetrieved(model)
                        } catch {
                            self.remoteRequestHandler?.onError()
                        }
                    }
                case .failure(_):
                    self.remoteRequestHandler?.onError()
                }
        }
    }
    
    func retrieveBeerList() {
        Alamofire.request(APIRouter.getBeersList())
            .validate()
            .responseData { responseAlamoFire in
                switch responseAlamoFire.result {
                case .success:
                    if let data = responseAlamoFire.result.value {
                        do {
                            let decoder = JSONDecoder()
                            decoder.keyDecodingStrategy = .convertFromSnakeCase
                            let model = try decoder.decode([Beer].self, from: data)
                            self.remoteRequestHandler?.onBeersRetrieved(model)
                        } catch {
                            self.remoteRequestHandler?.onError()
                        }
                    }
                case .failure(_):
                    self.remoteRequestHandler?.onError()
                }
        }
    }
    
    func retrieveLocalBeerList() throws -> [Beer] {
        
        guard let managedOC = CoreDataStore.managedObjectContext else {
            throw PersistenceError.managedObjectContextNotFound
        }
        
        let request: NSFetchRequest<BeerModel> = NSFetchRequest(entityName: String(describing: "BeerModel"))
        
        let beerModelList = try managedOC.fetch(request)
        
        
        let beerList = beerModelList.map() {
            return Beer(beerModel: $0)
        }
        
        return beerList
    }    
}

extension DataManager: BeerDetailInteractorToDataManagerProtocol {
    
    func saveBeer(beer: Beer) throws {
        guard let managedOC = CoreDataStore.managedObjectContext else {
            throw PersistenceError.managedObjectContextNotFound
        }

        if let beerModel = NSEntityDescription.entity(forEntityName: "BeerModel", in: managedOC),
            let volumeModel = NSEntityDescription.entity(forEntityName: "VolumeModel", in: managedOC) {
            let beerObj = BeerModel(entity: beerModel, insertInto: managedOC)
            beerObj.id = Int16(beer.id)
            beerObj.name = beer.name
            beerObj.beerDescription = beer.description
            beerObj.firstBrewed = beer.firstBrewed
            beerObj.imageUrl = beer.imageUrl
            let volumeObj = VolumeModel(entity: volumeModel, insertInto: managedOC)
            volumeObj.value = Int16(beer.volume.value)
            volumeObj.unit = beer.volume.unit
            beerObj.volume = volumeObj
            beerObj.tagline = beer.tagline
            beerObj.foodPairing = beer.foodPairing as NSArray
            do {
                try managedOC.save()
            } catch {
                throw PersistenceError.couldNotSaveObject
            }
        }
        
    }

    func deleteBeer(beer: Beer) {
        guard let managedOC = CoreDataStore.managedObjectContext else {
            localRequestHandler?.onError()
            return
        }
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "BeerModel")
        fetchRequest.predicate = NSPredicate(format: "id = %d", beer.id)
        
        var results: [NSManagedObject] = []
        
        do {
            results = try managedOC.fetch(fetchRequest)
        } catch {
            print("error executing fetch request: \(error)")
        }
        for beer in results {
            managedOC.delete(beer)
        }
        
        do {
            try managedOC.save()
        } catch {
            localRequestHandler?.onError()
        }
    }
    
    func checkIfBeerIsFavorite(beerId: Int) {
        guard let managedOC = CoreDataStore.managedObjectContext else {
            localRequestHandler?.onError()
            return
        }

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "BeerModel")
        fetchRequest.predicate = NSPredicate(format: "id = %d", beerId)
        
        var results: [NSManagedObject] = []
        
        do {
            results = try managedOC.fetch(fetchRequest)
        } catch {
            print("error executing fetch request: \(error)")
        }

        if results.count > 0 {
            localRequestHandler?.onFetchSuccess()
        } 
    }
}
