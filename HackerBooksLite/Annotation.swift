//
//  Annotation.swift
//  HackerBooksLite
//
//  Created by Alejandro Moreno Alberto on 27/9/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import Foundation
import RealmSwift

class Annotation: Object {
    
    dynamic var title = ""
    dynamic var text = ""
    dynamic var photo: Photo?
    dynamic var location: Location?
    dynamic var modificationDate = Date()
    let book = LinkingObjects(fromType: Book.self, property: "notes")
    
}
