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

class BooksTableViewController: UITableViewController {

    var notificationToken: NotificationToken?
    var _tagsResult: TagResult
    let searchController = UISearchController(searchResultsController: nil)
    var searchResults = try! Realm().objects(Tag.self)
    
    
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
    
    // UI
    
    //MARK: - Cell registration
    private func registerNib(){
        
        let nib = UINib(nibName: "BookTableViewCell", bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: BookTableViewCell.cellID)
        
    }
    
    // Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return searchResults.count
        }
        return _tagsResult.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searchController.isActive && searchController.searchBar.text != "" {
            return searchResults[section].name.capitalizingFirstLetter()
        }
        return _tagsResult[section].name.capitalizingFirstLetter()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
           return searchResults[section].books.count
        }
        return _tagsResult[section].books.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create the cell
        let cell = tableView.dequeueReusableCell(withIdentifier: BookTableViewCell.cellID, for: indexPath) as! BookTableViewCell
        
        let objects = _tagsResult[indexPath.section].books.sorted(byProperty: "title")
        var object = Book()
        if searchController.isActive && searchController.searchBar.text != "" {
            let search = searchResults[indexPath.section].books.sorted(byProperty: "title")
            object = search[indexPath.row]
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
            let search = searchResults[indexPath.section].books.sorted(byProperty: "title")
            object = search[indexPath.row]
        }else{
            object = objects[indexPath.row]
        }
        
        let vc = BookViewController(book: object)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func filterResultsWithSearchString(searchString: String) {
        let predicate = NSPredicate(format: "ANY books.title CONTAINS[c] %@", searchString) // 1
        _ = searchController.searchBar.selectedScopeButtonIndex // 2
        let realm = try! Realm()
        searchResults = realm.objects(Tag.self).filter(predicate) // 5
        
        tableView.reloadData()
        
    }
    
}

extension BooksTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text!
        filterResultsWithSearchString(searchString: searchString)
    }
}
