//
//  Location.swift
//  HackerBooksLite
//
//  Created by Alejandro Moreno Alberto on 27/9/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import Foundation
import RealmSwift

class Location: Object {
    
    dynamic var address = ""
    dynamic var latittude = 0.000
    dynamic var longitude = 0.000
}
