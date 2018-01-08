//
//  SettingsTableViewController.swift
//  RightManagement
//
//  Created by Baljeet Gaheer on 24/12/17.
//  Copyright © 2017 Munish Sethi. All rights reserved.
//

import UIKit
class SettingsTableViewController : UITableViewController {
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
