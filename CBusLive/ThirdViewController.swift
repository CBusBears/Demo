//
//  ThirdViewController.swift
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


class ThirdViewController: UITableViewController {
    
    var ref: FIRDatabaseReference!
    var itemList = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ref = FIRDatabase.database().reference()
        navigationController?.navigationBar.barTintColor = hexStringToUIColor(hex: "#00a5ff")
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Futura", size: 25)!]
        self.title = "Interests"
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.itemList = [Item]()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.itemList = [Item]()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        for data in singleTon.sharedInstance.array{
            itemList.append(data)
        }
        return (itemList.count)/5
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        for data in singleTon.sharedInstance.array{
            if data.title == cell?.textLabel?.text{
                let stri = data.des! + " This event is at "
                let n = data.location! + " Address: "
                let g = data.address!
                
                let alert = UIAlertController(title: data.title, message: stri + n + g
                    , preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        var titleList = [String]()
        let cell = tableView.dequeueReusableCell(withIdentifier: "title")!
        
        for item in itemList{
            titleList.append(item.title!)
        }
        cell.textLabel?.text = titleList[indexPath.row]
        
        return cell
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
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    @IBAction func Logout(_ sender: Any) {
        try! FIRAuth.auth()!.signOut()
        /*if let bundle = Bundle.main.bundleIdentifier {
         UserDefaults.standard.removePersistentDomain(forName: bundle)
         }*/
        self.performSegue(withIdentifier: "toLoginFromTerminary", sender: self)
    }
    
}


/*
class ThirdViewController: UITableViewController {
    
    var ref: FIRDatabaseReference!
    var itemList = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        navigationController?.navigationBar.barTintColor = hexStringToUIColor(hex: "#00a5ff")
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Futura", size: 25)!]
        self.title = "Interests"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //self.tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView!, numberOfRowsInSection section: Int) -> Int
    {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView!,
                   cellForRowAtIndexPath indexPath: IndexPath!) -> UITableViewCell!
    {
        
        let cell:UITableViewCell = UITableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:"cell")
        
        cell.textLabel?.text = tableData[indexPath.row]
        
        return cell
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        itemList = [Item]()
        
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
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    @IBAction func logout(_ sender: Any) {
        try! FIRAuth.auth()!.signOut()
        /*if let bundle = Bundle.main.bundleIdentifier {
         UserDefaults.standard.removePersistentDomain(forName: bundle)
         }*/
        self.performSegue(withIdentifier: "toLoginFromTerminary", sender: self)
    }
}*/

