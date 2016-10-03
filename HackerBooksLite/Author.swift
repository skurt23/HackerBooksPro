//
//  Author.swift
//  HackerBooksLite
//
//  Created by Alejandro Moreno Alberto on 27/9/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import Foundation
import RealmSwift

class Author: Object {
    
    dynamic var name = ""
    let books = LinkingObjects(fromType: Book.self, property: "authors")
}
