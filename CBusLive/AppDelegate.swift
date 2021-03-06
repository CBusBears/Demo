//
//  AppDelegate.swift
//  CBusLive
//
//  Created by Benjamin Hobson on 4/12/17.
//  Copyright © 2017 Benjamin Hobson. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var ref: FIRDatabaseReference!
    var itemList = [Item]()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FIRApp.configure()
        ref = FIRDatabase.database().reference()
        
         /*if let bundle = Bundle.main.bundleIdentifier {
         UserDefaults.standard.removePersistentDomain(forName: bundle)
         }*/
        
        
        ref.child("Events").observeSingleEvent(of: .value, with: { snapshot in
            let enumerator = snapshot.children
            while let item = enumerator.nextObject() as! FIRDataSnapshot? {
                //self.paths.append(item.key as String)
                
                self.ref.child("Events").child(item.key as String).observeSingleEvent(of: .value, with: { snapshot in
                    let postDict = snapshot.value as? [String : AnyObject] ?? [:]
                    let data = Item(address: postDict["Address"] as! String, author: postDict["Author"] as! String, date: postDict["Date"] as! String, description: postDict["Description"] as! String, latitude: Double(postDict["Latitude"] as! String)!, location: postDict["Location"] as! String, longitude: Double(postDict["Longitude"] as! String)!, title: postDict["Title"] as! String)
                    self.itemList.append(data)
                    
                    singleTon.sharedInstance.array = self.itemList
                    print("Number of initial items in list: ", self.itemList.count)
                })
            }
        })

        
        return true
    }


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

class singleTon: NSObject {
    class var sharedInstance : singleTon {
        struct Example {
            static let instance = singleTon()
        }
        return Example.instance
    }
    
    
    var array = [Item]()
    
}

public class Item: NSObject{
    
    var address: String?
    var author: String?
    var date: String?
    var des: String?
    var latitude: Double?
    var location: String?
    var longitude: Double?
    var title: String?
    
    init(address: String, author: String, date: String, description: String, latitude: Double, location: String, longitude: Double, title: String){
        
        self.address = address as String
        self.author = author as String
        self.date = date as String
        self.des = description as String
        self.latitude = latitude
        self.location = location as String
        self.longitude = longitude
        self.title = title as String
        
    }
    
}
