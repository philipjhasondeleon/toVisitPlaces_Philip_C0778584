//
//  Places.swift
//  toVisitPlaces_Philip_C0778584
//
//  Created by user175490 on 6/18/20.
//  Copyright © 2020 user175490. All rights reserved.
//

import Foundation

class Places{
    
    var placeLat: Double
    var placeLong: Double
    var placeName :String
    var city :String
    var postalCode : String
    var country : String
    
    init(placeLat:Double , placeLong: Double, placeName:String, city:String, postalCode: String, country:String) {
        self.placeLat = placeLat
        self.placeLong = placeLong
        self.placeName = placeName
        self.city = city
        self.postalCode = postalCode
        self.country = country
    }
    
    
}
