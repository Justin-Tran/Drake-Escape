//
//  SettingsPopoverViewController.swift
//  iOS-Project
//
//  Created by Rambo Wu on 11/22/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

class SettingsPopoverViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    var settingsView: SettingsTableViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func presentPopover(sourceController:UIViewController, sourceView:UIView, sourceRect:CGRect) {
        
        // Create the view controller we want to display as the popup.
        self.settingsView = SettingsTableViewController(title: "Candidates", preferredContentSize: CGSize(width: 200, height: 140))
        
        // Cause the views to be created in this view controller. Gets them added to the view hierarchy.
        let _ = self.settingsView?.view
        self.settingsView?.tableView.layoutIfNeeded()
        
        // Set attributes for the popover controller.
        // Notice we're get an existing object from the view controller we want to popup!
        let popoverMenuViewController = self.settingsView!.popoverPresentationController
        popoverMenuViewController?.permittedArrowDirections = .down
        popoverMenuViewController?.delegate = self
        popoverMenuViewController?.sourceView = sourceView
        popoverMenuViewController?.sourceRect = sourceRect
        
        // Show the popup.
        // Notice we are presenting form a view controller passed in. We need to present from a view controller
        // that has views that are already in the view hierarchy.
        sourceController.present(self.settingsView!, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
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
