//
//  NoteCollectionViewCell.swift
//  HackerBooksLite
//
//  Created by Alejandro Moreno Alberto on 2/10/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import UIKit

class NoteCollectionViewCell: UICollectionViewCell {
    
    static let cellID = "NoteCollectionViewCellID"
    static let cellHeight : CGFloat = 150.0
    
    private
    var _note: Annotation?

    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var modificationDateView: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func prepareForReuse() {
        syncNoteWithCell()
    }
    
    func prepareCell(note: Annotation){
        _note = note
        syncNoteWithCell()
    }
    
    func syncNoteWithCell(){
        if _note?.photo?.photoData != nil {
            photoView.image = UIImage(data: (_note?.photo?.photoData)!)
        }
        
        let date = _note?.modificationDate
        let format = DateFormatter()
        format.dateFormat = "HH:mm - dd/MM/yyyy"
        
        titleView.text = _note?.title
        modificationDateView.text = format.string(from: date!)
        
        
    }
    

}
