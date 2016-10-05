//
//  PdfViewController.swift
//  HackerBooksLite
//
//  Created by Alejandro Moreno Alberto on 2/10/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class PdfViewController: UIViewController {
    
    private
    var _book: Book
    
    let lastBook = try! Realm().objects(Tag.self).filter("name == 'Último libro leído'")
    
    
    
    @IBOutlet weak var pdfView: UIWebView!
    
    init(book: Book) {
        _book = book
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showPdf()
        
        if lastBook.count == 0{
            try! Realm().write {
                let tag = Tag()
                tag.name = "Último libro leído"
                tag.favorites = true
                try! Realm().add(tag)
                _book.tags.append(tag)
                
            }
        }else{
            try! Realm().write {
                try! Realm().delete(lastBook[0])
                let tag = Tag()
                tag.name = "Último libro leído"
                tag.favorites = true
                try! Realm().add(tag)
                _book.tags.append(tag)
                
            }
        }
        
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(PdfViewController.addNote))
        
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(bookDidChange), name: Notification.Name(rawValue: BookDidChangeNotification), object: nil)
        
        self.navigationItem.rightBarButtonItem = addButton
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        let center = NotificationCenter.default
        center.removeObserver(self)
    }
    
    func showPdf() {
        let mainBundle = Bundle.main
        let defaultPdf = mainBundle.url(forResource: "emptyPdf", withExtension: "pdf")!
        let defaultPdfData = try! Data(contentsOf: defaultPdf)
        pdfView.load(defaultPdfData, mimeType: "application/pdf", textEncodingName: "utf8", baseURL: URL(string: "http://www.google.com")!)
        let pdfURL = URL(string: (self._book.pdf?.pdfUrl)!)
        DispatchQueue.global(qos: .background).async {
            let pdfData = try! Data(contentsOf: pdfURL!)
            
            DispatchQueue.main.async {
                self.pdfView.load(pdfData, mimeType: "application/pdf", textEncodingName: "utf8", baseURL: URL(string: "http://www.google.com")!)
            }
            
        }
    }
    
    func addNote(){
        let vc = AnnotationViewController(book: _book)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    //MARK - Notification handlers
    
    func bookDidChange(notification: NSNotification)  {
        
        let info = notification.userInfo!
        let book = info[bookKey] as? Book
        
        // Actualizar el modelo
        _book = book!
        
        // Sincronizar las vistas
        showPdf()
        
    }
    
}
