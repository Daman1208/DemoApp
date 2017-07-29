//
//  GeoPoint.swift
//  TheBot
//
//  Created by Daman on 27/07/17.
//  Copyright © 2017 Tarsem. All rights reserved.
//

import UIKit
import RealmSwift

let kLatitude = "latitude"
let kLongitude = "longitude"

class GeoPoint: NSObject {
    
    var latitude:Double = 0.0
    var longitude:Double = 0.0
    var accuracy:Double = 0.0

}

