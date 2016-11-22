//
//  SettingsTableViewController.swift
//  iOS-Project
//
//  Created by Rambo Wu on 11/22/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import Firebase

class SettingsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tableView:UITableView = UITableView()
    
    convenience init(title:String, preferredContentSize: CGSize)
    {
        self.init()
        self.preferredContentSize = preferredContentSize
        self.title = title
        self.modalPresentationStyle = UIModalPresentationStyle.popover
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // Code used from TestPopoverControllerSwift
        // Modified to make compatible with Swift 3.0
        self.tableView.frame         =   CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.preferredContentSize.width, height: self.preferredContentSize.height))
        self.tableView.delegate      =   self
        self.tableView.dataSource    =   self
        
        // Register the class we'll use to create table view cells for the given reuse id.
        // In this case, we'll be using the pre-defined UITableViewCell class.
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        
        // Add the table view to the main view hierarchy for this view controller.
        self.view.addSubview(self.tableView)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath as IndexPath)
        
        if indexPath.row == 0
        {
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.font = UIFont(name: "It's Too Late", size: 30)
            cell.textLabel?.text = "SETTINGS"
        }
        
        if indexPath.row == 1
        {
            cell.textLabel?.font = UIFont(name: "It's Too Late", size: 30)
            // make this different for final phase?
            cell.textLabel?.text = "MUSIC                ON"
        }
        if indexPath.row == 2
        {
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.font = UIFont(name: "It's Too Late", size: 30)
            cell.textLabel?.text = "LOG OUT"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if indexPath.row == 1
        {
            cell?.textLabel?.font = UIFont(name: "It's Too Late", size: 30)
            // make this different for final phase?
            if cell?.textLabel?.text == "MUSIC                ON"
            {
                cell?.textLabel?.text = "MUSIC              OFF"
            }
            else
            {
                cell?.textLabel?.text = "MUSIC                ON"
            }
        }
        if indexPath.row == 2
        {
            //try! FIRAuth.auth()!.signOut()
            //self.performSegue(withIdentifier: "logout", sender: self)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
