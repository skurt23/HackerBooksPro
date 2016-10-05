//
//  PhotoViewController.swift
//  HackerBooksLite
//
//  Created by Alejandro Moreno Alberto on 2/10/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class PhotoViewController: UIViewController {

    var _note: Annotation
    
    @IBOutlet weak var photoView: UIImageView!
    @IBAction func takePhoto(_ sender: AnyObject) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        let alert = UIAlertController(title: "Take photo", message: nil, preferredStyle: .actionSheet)
        let libraryAction = UIAlertAction(title: "From Library", style: .default, handler: { (UIAlertAction) in
            
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            
            self.present(picker, animated: true, completion: nil)
            }
        )
        let cameraAction = UIAlertAction(title: "From Camera", style: .default, handler: { (UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
                picker.sourceType = UIImagePickerControllerSourceType.camera
            }else{
                picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            }
            
            self.present(picker, animated: true, completion: nil)
            }
        )
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(libraryAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    @IBAction func deletePhoto(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Are you sure?", message: nil, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete", style: .default, handler: { (UIAlertAction) in
            let mainBundle = Bundle.main
            let defaultImg = mainBundle.url(forResource: "noImage", withExtension: "png")!
            try! Realm().write {
                self._note.photo?.photoData = try! Data(contentsOf: defaultImg)
            }
            
            self.photoView.image = UIImage(data: (self._note.photo?.photoData)!)
            
            }
        )
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)

    }
    
    init(note: Annotation) {
        _note = note
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if _note.photo != nil{
            
            photoView.image = UIImage(data: (_note.photo?.photoData)!)
        }else{
            let mainBundle = Bundle.main
            let defaultImg = mainBundle.url(forResource: "noImage", withExtension: "png")!
            try! Realm().write {
                self._note.photo = Photo()
                self._note.photo?.photoData = try! Data(contentsOf: defaultImg)
            }
            
            photoView.image = UIImage(data: (self._note.photo?.photoData)!)
            
        }
        
    }
    

}

extension PhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // extraemos la foto del diccionario
        let screenBounds = UIScreen.main.bounds
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let resizedImage = image.resizeWith(width: screenBounds.width)
        let data = UIImagePNGRepresentation(resizedImage!)
        
        let photo = Photo()
        try! Realm().write {
            photo.photoData = data!
            try! Realm().add(photo)
            _note.photo = photo
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
}
