//
//  JsonProcessings.swift
//  HackerBooksLite
//
//  Created by Alejandro Moreno Alberto on 27/9/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import RealmSwift
import UIKit

//MARK: - Aliases
typealias JSONObject    = String    // We'll only receive strings
typealias JSONDictionary = [String : JSONObject]
typealias JSONArray = [JSONDictionary]

//MARK: - Decodification
func decode(book dict: JSONDictionary) throws -> Void{
    
    // extract from dict
    func extract(key: String) -> String{
        return dict[key]!   // we know it can't be missing because we validated first!
    }
    
    // parsing
    let authors = parseCommaSeparated(string: extract(key: "authors"))
    let tags = parseCommaSeparated(string: extract(key: "tags"))
    let imgURL = URL(string: extract(key: "image_url"))!
    let cover = Cover()
    let pdfURL = String(extract(key: "pdf_url"))!
    let pdf = Pdf()
    pdf.pdfUrl = pdfURL
    let title = extract(key: "title").capitalized
    DispatchQueue.global(qos: .background).async {
        let imgData = try! Data(contentsOf: imgURL)
        DispatchQueue.main.async {
            let realm = try! Realm()
            cover.imageData = imgData
            try! realm.write {
                realm.add(cover)
                realm.add(pdf)
                let book = Book()
                book.title = title
                for tag in tags{
                    let object = Tag()
                    object.name = tag
                    realm.add(object)
                    let someTags = realm.objects(Tag.self).filter("name contains '" + tag + "'")
                    book.tags.append(objectsIn: someTags)
                }
                for author in authors{
                    let object = Author()
                    object.name = author
                    realm.add(object)
                    let someAuthors = realm.objects(Author.self).filter("name contains '" + author + "'")
                    book.authors.append(someAuthors[0])
                }
                book.image = cover
                book.pdf = pdf
                
                realm.add(book)
            }

        }
    }
    
    
    
    
    
    
}


//MARK: - Parsing
func parseCommaSeparated(string s: String)->[String]{
    
    return s.components(separatedBy: ",").map({ $0.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }).filter({ $0.characters.count > 0})
}


