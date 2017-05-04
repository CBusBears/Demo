//
//  FirstViewController.swift
//  CBusLive
//
//  Created by Benjamin Hobson on 4/12/17.
//  Copyright © 2017 Benjamin Hobson. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseDatabase
import UIKit
import MapKit

class FirstViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var map: MKMapView!
    var ref: FIRDatabaseReference!
    var handle: FIRDatabaseHandle?
    var itemList = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        navigationController?.navigationBar.barTintColor = hexStringToUIColor(hex: "#00a5ff")
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Futura", size: 25)!]
        self.title = "CBus"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let initialLocation = CLLocation(latitude: 39.975918, longitude: -82.997326)
        centerMapOnLocation(location: initialLocation)
        ref.child("Events").observeSingleEvent(of: .value, with: { snapshot in
            let enumerator = snapshot.children
            while let item = enumerator.nextObject() as! FIRDataSnapshot? {
                //self.paths.append(item.key as String)
                
                self.ref.child("Events").child(item.key as String).observeSingleEvent(of: .value, with: { snapshot in
                    let postDict = snapshot.value as? [String : AnyObject] ?? [:]
                    let data = Item(address: postDict["Address"] as! String, author: postDict["Author"] as! String, date: postDict["Date"] as! String, description: postDict["Description"] as! String, latitude: Double(postDict["Latitude"] as! String)!, location: postDict["Location"] as! String, longitude: Double(postDict["Longitude"] as! String)!, title: postDict["Title"] as! String)
                    
                    let point = MKPointAnnotation()
                    point.coordinate = CLLocationCoordinate2D(latitude: data.latitude!,longitude: data.longitude!)
                    point.title = data.title
                    point.subtitle = data.location
                    let pin = MKPinAnnotationView(annotation: point, reuseIdentifier: "pin")
                    self.map.addAnnotation(pin.annotation!)
                    
                    self.itemList.append(data)
                    singleTon.sharedInstance.array = self.itemList
                })
            }
        })
    }
    
    
    /*let tabBarController =
     let destinationViewController = tabBarController.viewControllers?[2] as! ThirdViewController // or whatever tab index you're trying to access
     destinationViewController.yup = "Cookies"
     destinationViewController.itemList = itemList*/
    
    override func viewDidDisappear(_ animated: Bool) {
        
        self.map.removeAnnotations(self.map.annotations)
        
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0, green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0, blue: CGFloat(rgbValue & 0x0000FF) / 255.0, alpha: CGFloat(1.0))
        
    }
    
    func centerMapOnLocation(location: CLLocation) {
        
        let regionRadius: CLLocationDistance = 10000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        map.setRegion(coordinateRegion, animated: true)
        
    }

}




