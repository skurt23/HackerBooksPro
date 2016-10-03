//
//  String.swift
//  HackerBooksLite
//
//  Created by Alejandro Moreno Alberto on 28/9/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import Foundation

extension String{
    func capitalizingFirstLetter() -> String {
        let first = String(characters.prefix(1)).capitalized
        let other = String(characters.dropFirst())
        return first + other
    }
}
