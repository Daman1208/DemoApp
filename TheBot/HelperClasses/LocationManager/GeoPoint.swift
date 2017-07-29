//
//  GeoPoint.swift
//  Social Gram
//
//  Created by Daman on 25/10/16.
//  Copyright © 2016 Bison. All rights reserved.
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

