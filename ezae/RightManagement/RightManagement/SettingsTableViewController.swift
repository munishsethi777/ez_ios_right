//
//  SettingsTableViewController.swift
//  RightManagement
//
//  Created by Baljeet Gaheer on 24/12/17.
//  Copyright © 2017 Munish Sethi. All rights reserved.
//

import UIKit
class SettingsTableViewController : UITableViewController {
    var isGotoAchivement:Bool = false
    var isGotoEvents:Bool = false
    var isGoToNotes:Bool=false
    var isGoToProfile = false;
    override func viewWillAppear(_ animated: Bool){
        if(isGotoAchivement){
            isGotoAchivement = false
            self.performSegue(withIdentifier: "Achievements", sender: self)
        }
        if(isGotoEvents){
            isGotoEvents = false
            self.performSegue(withIdentifier: "Events", sender: self)
        }
        if(isGoToNotes){
            isGoToNotes = false
            self.performSegue(withIdentifier: "Notes", sender: self)
            
        }
        if(isGoToProfile){
            isGoToProfile = false
            self.performSegue(withIdentifier: "UpdateProfile", sender: self)
            
        }
        
    }
    @IBAction func logoutTapped(_ sender: Any) {
        logout()
    }
    
    private func logout(){
        let refreshAlert = UIAlertController(title: "Logout", message: "Are you realy want to logout.", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            PreferencesUtil.sharedInstance.resetDefaults()
            //self.performSegue(withIdentifier: "showLoginViewController", sender: nil)
            self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
           
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
}
