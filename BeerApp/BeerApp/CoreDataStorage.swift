//
//  CoreDataStorage.swift
//  BeerApp
//
//  Created by Leandro Paiva Andrade on 5/4/18.
//  Copyright © 2018 Leandro. All rights reserved.
//

import CoreData
import UIKit

class CoreDataStore {
    
    static var persistentStoreCoordinator: NSPersistentStoreCoordinator? {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            return appDelegate.persistentContainer.persistentStoreCoordinator
        }
        return nil
    }
    
    static var managedObjectModel: NSManagedObjectModel? {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            return appDelegate.persistentContainer.managedObjectModel
        }
        return nil
    }
    
    static var managedObjectContext: NSManagedObjectContext? {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            return appDelegate.persistentContainer.viewContext
        }
        return nil
    }
    
}

enum PersistenceError: Error {
    case managedObjectContextNotFound
    case couldNotSaveObject
    case couldNotDeleteObject
    case objectNotFound
}

