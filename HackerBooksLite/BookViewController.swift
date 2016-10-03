//
//  BookViewController.swift
//  HackerBooksLite
//
//  Created by Alejandro Moreno Alberto on 30/9/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import UIKit

class BookViewController: UIViewController {
    
    typealias Authors = [String]
    
    var _book: Book
    
    @IBOutlet weak var favoriteItem: UIBarButtonItem!
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var authorsView: UILabel!
    @IBOutlet weak var coverView: UIImageView!
    
    
    @IBAction func notes(_ sender: AnyObject) {
        
        let vc = AnnotationsCollectionViewController(book: _book)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func readPdf(_ sender: AnyObject) {
        
        let vc = PdfViewController(book: _book)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func addToFavs(_ sender: AnyObject) {
        
    }
    
    init(book: Book) {
        _book = book
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        syncWithBook()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func syncWithBook() {
        
        var authors: Authors = []
        
        
        for author in (_book.authors){
            authors.append(author.name)
        }

        
        if _book.isFavorite{
            favoriteItem.title = "★"
        }else{
            favoriteItem.title = "☆"
        }
        
        titleView.text = _book.title
        authorsView.text = authors.joined(separator: ",")
        coverView.image = UIImage(data: (_book.image?.imageData)!)
        coverView.layer.cornerRadius = 10
        coverView.clipsToBounds = true
        coverView.layer.borderWidth = 3
        coverView.layer.borderColor = UIColor.black.cgColor
        
        
    }
    


}
