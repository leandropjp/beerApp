//
//  Beer.swift
//  BeerApp
//
//  Created by Leandro Paiva Andrade on 5/4/18.
//  Copyright © 2018 Leandro. All rights reserved.
//

import Foundation
import CoreData

class Beer: Codable {
    var id: Int = -1
    var name: String = ""
    var tagline: String = ""
    var firstBrewed: String = ""
    var imageUrl: String = ""
    var description: String = ""
    var volume: Volume = Volume(value: -1, unit: "")
    var foodPairing: [String] = []
    
    init(beerModel: BeerModel) {
        self.id = Int(beerModel.id)
        self.name = beerModel.name ?? ""
        self.tagline = beerModel.tagline ?? ""
        self.firstBrewed = beerModel.firstBrewed ?? ""
        self.imageUrl = beerModel.imageUrl ?? ""
        self.description = beerModel.beerDescription ?? ""
        self.volume =  Volume.init(value: Int(beerModel.volume?.value ?? -1), unit: beerModel.volume?.unit ?? "")
        self.foodPairing = beerModel.foodPairing as! [String]
    }
}

class Volume: Codable {
    var value: Int = -1
    var unit: String = ""
    
    init(value: Int, unit: String) {
        self.value = value
        self.unit = unit
    }
}
