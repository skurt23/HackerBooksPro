//
//  AnnotationsCollectionViewController.swift
//  HackerBooksLite
//
//  Created by Alejandro Moreno Alberto on 30/9/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

private let reuseIdentifier = "Cell"

class AnnotationsCollectionViewController: UICollectionViewController {
    
    var notificationToken: NotificationToken? = nil
    
    typealias NotesResults = Results<Annotation>
    private
    var _book: Book
    
    var results = try!Realm().objects(Book.self)
    
    init(book: Book) {
        results = results.filter("title == '" + book.title! + "'")
        _book = results[0]
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: 140, height: 150)
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        registerNib()
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(AnnotationsCollectionViewController.addNote))
        
        // Observe Notifications
        notificationToken = results.addNotificationBlock { [weak self] (changes: RealmCollectionChange) in
            guard let collectionView = self?.collectionView else { return }
            switch changes {
            case .initial(_):
                // Results are now populated and can be accessed without blocking the UI
                collectionView.reloadData()
                break
            case .update(_, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                // Query results have changed, so apply them to the UITableView
                collectionView.performBatchUpdates({
                    collectionView.insertItems(at: insertions.map { IndexPath(row: $0, section: 0) })
                    collectionView.deleteItems(at: deletions.map { IndexPath(row: $0, section: 0) })
                    collectionView.reloadItems(at: modifications.map { IndexPath(row: $0, section: 0) })
                    }, completion: { _ in })
                break
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
                break
            }
        }
        
        self.navigationItem.rightBarButtonItem = addButton
        collectionView?.backgroundColor = UIColor(white: 0.9, alpha: 1)
        collectionView?.reloadData()
    }
    
    deinit {
        notificationToken?.stop()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        registerNib()
    }
    
    private func registerNib(){
        
        let nib = UINib(nibName: "NoteCollectionViewCell", bundle: Bundle.main)
        collectionView?.register(nib, forCellWithReuseIdentifier: NoteCollectionViewCell.cellID)
        
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _book.notes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoteCollectionViewCell.cellID, for: indexPath) as! NoteCollectionViewCell
    
        let note = _book.notes[indexPath.row]
        
        cell.prepareCell(note: note)
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let editNote = _book.notes[indexPath.row]
        let vc = AnnotationViewController(book: _book, note: editNote)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func addNote(){
        let vc = AnnotationViewController(book: _book)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }


}
