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
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(PdfViewController.addNote))
        
        self.navigationItem.rightBarButtonItem = addButton
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
}
