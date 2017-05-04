//
//  PhotoMapViewController.swift
//  Photo Map
//
//  Created by Nicholas Aiwazian on 10/15/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

@objc protocol PhotoViewControllerDelegte {
    func photoViewController(onTap: )
}

class PhotoMapViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate,LocationsViewControllerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var editedImage : UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //one degree of latitude is approximately 111 kilometers (69 miles) at all times.
        let sfRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.783333, -122.416667), 
        MKCoordinateSpanMake(0.1, 0.1))
        mapView.setRegion(sfRegion, animated: false)
        // Do any additional setup after loading the view.
        self.mapView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "tagSegue" {
            let vc = segue.destination as! LocationsViewController
            vc.delegate = self
        } else if segue.identifier == "fullImageSegue" {
            let vc = segue.destination as! FullImageViewController
            vc.image = editedImage.
        }
    
    }
    
    func locationsPickedLocation(controller: LocationsViewController, latitude: NSNumber, longitude: NSNumber) {
        let sfRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(CLLocationDegrees(latitude.doubleValue), CLLocationDegrees(longitude.doubleValue)),
                                              MKCoordinateSpanMake(0.1, 0.1))
        mapView.setRegion(sfRegion, animated: false)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(latitude.doubleValue), CLLocationDegrees(longitude.doubleValue))
        
        annotation.title = "Picture!"
        mapView.addAnnotation(annotation)
        
        navigationController?.popViewController(animated: true)
    }
    
    func mapView(_ viewFormapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "myAnnotationView"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
        if (annotationView == nil) {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            annotationView!.canShowCallout = true
            annotationView!.leftCalloutAccessoryView = UIImageView(frame: CGRect(x:0, y:0, width: 50, height:50))
        }
        
        
        let imageView = annotationView?.leftCalloutAccessoryView as! UIImageView
        
        var resizeRenderImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
        resizeRenderImageView.layer.borderColor = UIColor.white.cgColor
        resizeRenderImageView.layer.borderWidth = 3.0
        resizeRenderImageView.contentMode = .scaleAspectFit
        resizeRenderImageView.image = editedImage
        
        UIGraphicsBeginImageContext(resizeRenderImageView.frame.size)
        resizeRenderImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        var thumbnail = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        imageView.image = resizeRenderImageView.image
        
        let rightButton = UIButton(type: UIButtonType.detailDisclosure);
        rightButton.addTarget(self, action: "buttonTapped:", for: UIControlEvents.touchUpInside)
        annotationView?.rightCalloutAccessoryView = rightButton;
        
        /*let button = annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        button.addTarget(self, action: "buttonTapped:", forControlEvents: UIControlEvents.TouchUpInside)*/
        
        return annotationView
    }
    
    func buttonTapped (){
        
    }
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // Do something with the images (based on your use case)
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: {
        
            self.performSegue(withIdentifier: "tagSegue", sender:self)
        })
        
    }
    
    @IBAction func onCameraClick(_ sender: Any) {
        
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(vc, animated: true, completion: nil)
    }

}
