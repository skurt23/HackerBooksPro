//
//  BookTableViewCell.swift
//  HackerBooksLite
//
//  Created by Alejandro Moreno Alberto on 29/9/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import UIKit

class BookTableViewCell: UITableViewCell {
    
    typealias TagAndAuthors = [String]
    
    
    //MARK: - Static vars
    static let cellID = "BookTableViewCellID"
    static let cellHeight : CGFloat = 66.0
    
    
    //MARK: - private interface
    private
    var _book : Book?
    
    private
    let _nc = NotificationCenter.default
    private
    var _bookObserver : NSObjectProtocol?
    

    @IBOutlet weak var coverView: UIImageView!
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var authorsView: UILabel!
    @IBOutlet weak var tagsView: UILabel!
    
    //MARK: - Lifecycle
    
    // Sets the view in a neutral state, before being reused
    override func prepareForReuse() {
        syncWithBook()
    }
    
    deinit {
    }
    
    func prepareCell(book: Book) {
        _book = book
        syncWithBook()
    }
    
    //MARK: - Utils
    func syncWithBook(){
        
        
        
        
        
        
        var authors: TagAndAuthors = []
        var tags: TagAndAuthors = []
        
        for author in (_book?.authors)!{
            authors.append(author.name)
        }
        
        
        for tag in (_book?.tags)!{
            tags.append(tag.name)
        }
        
        
        
        
        titleView.text = _book?.title
        authorsView.text = authors.joined(separator: ",")
        tagsView.text = tags.joined(separator: ",")
        coverView.image = UIImage(data: (self._book?.image?.imageData)!)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    

    
}
