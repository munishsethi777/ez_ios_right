//
//  ModuleViewController.swift
//  RightManagement
//
//  Created by Baljeet Gaheer on 02/12/17.
//  Copyright © 2017 Munish Sethi. All rights reserved.
//

import UIKit
class ModuleViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
   
    @IBOutlet weak var moduleTrainingView: UITableView!
    var array =  ["Module1", "Module2", "Module3", "Module4","Module5","Module6","Module7","Module8","Module9"]
    override func viewDidLoad() {
        super.viewDidLoad()
        moduleTrainingView.delegate = self
        moduleTrainingView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ModuleTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? UITableViewCell
        cell?.textLabel?.text = array[indexPath.section]
        return cell!
    }
    
    
    
}

