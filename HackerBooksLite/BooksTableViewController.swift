//
//  BooksTableViewController.swift
//  HackerBooksLite
//
//  Created by Alejandro Moreno Alberto on 27/9/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

typealias TagResult = Results<Tag>
let bookKey = "Book"
let BookDidChangeNotification = "BookDidChange"

class BooksTableViewController: UITableViewController {

    var notificationToken: NotificationToken?
    var _tagsResult: TagResult
    let searchController = UISearchController(searchResultsController: nil)
    var booksResults = try! Realm().objects(Book.self)
    var favoriteTag = try! Realm().objects(Tag.self).filter("name == 'Favoritos'")
    
    
    //MARK: - Init & Lifecycle
    init(tags: TagResult, style : UITableViewStyle = .plain) {
        _tagsResult = tags
        super.init(nibName: nil, bundle: nil)   // default options
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "HackersBooksPro"
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        registerNib()
        self.tableView.reloadData()
        
        // Set results notification block
        self.notificationToken = _tagsResult.addNotificationBlock { (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                self.tableView.reloadData()
                break
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the TableView
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self.tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self.tableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self.tableView.endUpdates()
                break
            case .error(let err):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(err)")
                break
            }
        }
        
    }
        
    //MARK: - Cell registration
    private func registerNib(){
        
        let nib = UINib(nibName: "BookTableViewCell", bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: BookTableViewCell.cellID)
        
    }
    
    // Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return 1
        }
        return _tagsResult.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searchController.isActive && searchController.searchBar.text != "" {
            return "Resultados"
        }
        return _tagsResult[section].name.capitalizingFirstLetter()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
           return booksResults.count
        }
        return _tagsResult[section].books.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create the cell
        let cell = tableView.dequeueReusableCell(withIdentifier: BookTableViewCell.cellID, for: indexPath) as! BookTableViewCell
        
        let objects = _tagsResult[indexPath.section].books.sorted(byProperty: "title")
        var object = Book()
        if searchController.isActive && searchController.searchBar.text != "" {
            object = booksResults[indexPath.row]//search[indexPath.row]
        }else{
            object = objects[indexPath.row]
            
        }
        
        
        
        cell.prepareCell(book: object)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BookTableViewCell.cellHeight
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let realm = try! Realm()
        if editingStyle == .delete {
            realm.beginWrite()
            realm.delete(_tagsResult[indexPath.row])
            try! realm.commitWrite()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let objects = _tagsResult[indexPath.section].books.sorted(byProperty: "title")
        var object = Book()
        if searchController.isActive && searchController.searchBar.text != "" {
            object = booksResults[indexPath.row]//search[indexPath.row]
        }else{
            object = objects[indexPath.row]
        }
        
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone{
            let vc = BookViewController(book: object)
            self.navigationController?.pushViewController(vc, animated: true)
        }else if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad{
            let nc = NotificationCenter.default
            let notif = Notification(name: NSNotification.Name(rawValue: BookDidChangeNotification), object: self, userInfo: [bookKey:object])
            nc.post(notif)
        }
        
    }
    
    func filterResultsWithSearchString(searchString: String) {

        let predicateTwo = NSPredicate(format: "title BEGINSWITH[c] %@", searchString)
        _ = searchController.searchBar.selectedScopeButtonIndex
        let realm = try! Realm()
        booksResults = realm.objects(Book.self).filter(predicateTwo)
       
        tableView.reloadData()
        
    }
    
}

extension BooksTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text!
        filterResultsWithSearchString(searchString: searchString)
    }
}
