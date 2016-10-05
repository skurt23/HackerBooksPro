//
//  Tag.swift
//  HackerBooksLite
//
//  Created by Alejandro Moreno Alberto on 27/9/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import Foundation
import RealmSwift

class Tag: Object {
    
    dynamic var name = ""
    dynamic var favorites = false
    let books = LinkingObjects(fromType: Book.self, property: "tags")
}
