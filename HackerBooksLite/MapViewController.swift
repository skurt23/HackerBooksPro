//
//  MapViewController.swift
//  HackerBooksLite
//
//  Created by Alejandro Moreno Alberto on 4/10/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController{
    
    var _note: Annotation?
    var _notes: [Annotation]?
    let regionRadius: CLLocationDistance = 10

    @IBOutlet weak var mapView: MKMapView!
    
    init(note: Annotation?) {
        _note = note
        super.init(nibName: nil, bundle: nil)
    }
    convenience init (notes: [Annotation]){
        self.init(note: nil)
        _notes = notes
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let location = CLLocation(latitude: (_note?.location?.latitude)!, longitude: (_note?.location?.longitude)!)
        
        centerMapOnLocation(location: location)
    }
    
    // MARK: Utils
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}
