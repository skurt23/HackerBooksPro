//
//  Controllers.swift
//  HackerBooksLite
//
//  Created by Alejandro Moreno Alberto on 27/9/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import UIKit

extension UIViewController{
    
    func wrappedInNavigationController()->UINavigationController{
        return UINavigationController(rootViewController: self)
    }
}
