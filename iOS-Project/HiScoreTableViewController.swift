//
//  HiScoreTableViewController.swift
//  iOS-Project
//
//  Created by Rambo Wu on 10/26/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import Firebase

class HiScoreTableViewController: UITableViewController {
    
    var highScoreList: [UserInfo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        let ref = FIRDatabase.database().reference(withPath: "users")
        
        ref.queryOrdered(byChild: "highScore").observeSingleEvent(of: .value, with: {(snapshot) in

            var count:Int = 0
            
            for item in snapshot.children
            {
                if count >= 8
                {
                    break
                }
                let userInfoItem = UserInfo(snapshot: item as! FIRDataSnapshot)
                self.highScoreList.append(userInfoItem)
                count = count + 1
            }
            self.tableView.reloadData()
        })
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return highScoreList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        
        // The first cell will be for the High Score title label and the back button
        if indexPath.row == 0
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "topHiScoreID", for: indexPath)
        }
        else
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "hiScoreID", for: indexPath)
        }
        
        // Makes every other cell light gray for better UI look
        if indexPath.row % 2 == 0
        {
            cell?.backgroundColor = UIColor.lightGray
        }
        
        if indexPath.row > 0 && highScoreList.count > 1
        {
            let userInfo:UserInfo = highScoreList[highScoreList.count - indexPath.row]
            cell?.textLabel?.text = userInfo.email
            cell?.detailTextLabel?.text = "\(userInfo.highScore!)"
        }
        
        return cell!
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
