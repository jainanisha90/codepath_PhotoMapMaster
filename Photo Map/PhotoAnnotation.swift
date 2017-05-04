//
//  PhotoAnnotation.swift
//  Photo Map
//
//  Created by Anisha Jain on 5/3/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import Foundation
import MapKit

class PhotoAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0)
    var photo: UIImage!
    
    var title: String? {
        return "\(coordinate.latitude)"
    }
}
