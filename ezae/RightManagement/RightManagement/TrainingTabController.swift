//
//  TrainingTabController.swift
//  RightManagement
//
//  Created by Baljeet Gaheer on 21/12/17.
//  Copyright © 2017 Munish Sethi. All rights reserved.
//

import UIKit
class TrainingTabController : UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "< Back", style: .plain, target: self, action: #selector(backAction))
        
        // Do any additional setup if required.
    }
    
    func backAction(){
        //print("Back Button Clicked")
        self.performSegue(withIdentifier: "showDashboard", sender: nil)
    }
    
}
