//
//  PresentationViewController.swift
//  HackerBooksLite
//
//  Created by Alejandro Moreno Alberto on 28/9/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import UIKit

class PresentationViewController: UIViewController {

    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    var loading: Bool?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.activityView.isHidden = false
        self.activityView.startAnimating()
        
    }
    
}
