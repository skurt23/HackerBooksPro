//
//  Book.swift
//  HackerBooksLite
//
//  Created by Alejandro Moreno Alberto on 27/9/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import Foundation
import RealmSwift

typealias Authors = [Author]
typealias Title = String

class Book: Object {
    
    let authors = List<Author>()
    dynamic var title: String? = ""
    let tags = List<Tag>()
    dynamic var pdf: Pdf?
    dynamic var image: Cover?
    dynamic var isFavorite = false
    let notes = List<Annotation>()
    
    override static func indexedProperties() -> [String] {
        return ["title", "authors", "isFavorite"]
    }
}


