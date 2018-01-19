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
    var loggedInUserSeq: Int = 0
    var loggedInCompanySeq: Int = 0
    var selectedModuleSeq: Int = 0
    var selectedLpSeq: Int = 0
    var moduleCount: Int = 0
    var moduleArr: [Any] = []
    var refreshControl:UIRefreshControl!
    var  progressHUD: ProgressHUD!
    var cache:NSCache<AnyObject, AnyObject>!
    var isLaunch = false
    override func viewDidLoad() {
        super.viewDidLoad()
        cache = NSCache()
        moduleTrainingView.delegate = self
        moduleTrainingView.dataSource = self
        self.loggedInUserSeq =  PreferencesUtil.sharedInstance.getLoggedInUserSeq()
        self.loggedInCompanySeq =  PreferencesUtil.sharedInstance.getLoggedInCompanySeq()
        getModules()
        if #available(iOS 10.0, *) {
            refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(refreshView), for: .valueChanged)
            moduleTrainingView.refreshControl = refreshControl
        }
        progressHUD = ProgressHUD(text: "Loading")
        self.view.addSubview(progressHUD)
    }
    
    
    func refreshView(refreshControl: UIRefreshControl) {
        cache = NSCache()
        getModules()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moduleCount
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ModuleTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ModuleTableViewCell
        let section: Int = indexPath.row
            let moduleJson = moduleArr[section] as! [String: Any]
            var moduleImageUrl = moduleJson["imagepath"] as? String
            var progressStr = moduleJson["progress"] as? String
            var moduleType = moduleJson["moduletype"] as! String
            var leaderboardRankStr = moduleJson["leaderboard"] as? String
            var lpSeqStr = moduleJson["learningPlanSeq"] as? String
            var seqStr = moduleJson["seq"] as? String
            var lpSeq = 0
            if(lpSeqStr != nil){
                 lpSeq = Int(lpSeqStr!)!
            }
            let seq = Int(seqStr!)!
            if(leaderboardRankStr == nil){
                leaderboardRankStr = "0"
            }
            let rank: Int = Int(leaderboardRankStr!)!
            let rankStr = String(rank) + "\nLeaderboard"
            if(progressStr == nil){
                progressStr = "0"
            }
            let progress: Int = Int(progressStr!)!
            if(moduleImageUrl == nil || (moduleImageUrl?.isEmpty)!){
                moduleImageUrl = "dummy.jpg"
            }
            if (self.cache.object(forKey: seqStr as AnyObject) != nil){
                cell?.moduleImageView?.image = self.cache.object(forKey: seqStr as AnyObject) as? UIImage
            }else {
                moduleImageUrl = StringConstants.IMAGE_URL + "modules/" + moduleImageUrl!
                if let url = NSURL(string: moduleImageUrl!) {
                    if let data = NSData(contentsOf: url as URL) {
                        let img = UIImage(data: data as Data)
                        cell?.moduleImageView.image = UIImage(data: data as Data)
                        self.cache.setObject(img!, forKey: seqStr as AnyObject)
                    }
                }
            }
            cell?.moduleTitleLabel.text = moduleJson["title"] as? String
            var points = moduleJson["points"] as? String
            if(points == nil){
                points = "0"
            }
            var score = moduleJson["score"] as? String
            if(score == nil){
                score = "0"
            }
            cell?.pointsLabel.text = points
            cell?.scoreLabel.text = score
            var buttonTitle: String = "Launch"
            if(progress > 0 && progress < 100){
                buttonTitle = "In Progress"
            }
            if(progress == 100){
                buttonTitle = "Review"
            }
            cell?.lauchModuleButton.setTitle(buttonTitle, for: .normal)
            cell?.lauchModuleButton.tag = seq
            cell?.lauchModuleButton.titleLabel?.tag = lpSeq
            cell?.lauchModuleButton.addTarget(self, action:#selector(launchModule), for: .touchUpInside)
            if(moduleType == "quiz" && rank > 0 && progress == 100){
                cell?.leaderboardLabel.text = rankStr
            }else{
                if(progress > 0){
                    cell?.leaderboardLabel.text = String(progress)+"%\nCompleted"
                }else{
                    cell?.leaderboardLabel.isHidden = true
                }
            }
        return cell!
    }
    
    func getModules(){
        let args: [Int] = [self.loggedInUserSeq,self.loggedInCompanySeq]
        let apiUrl: String = MessageFormat.format(pattern: StringConstants.GET_MODULES, args: args)
        var success : Int = 0
        var message : String? = nil
        ServiceHandler.instance().makeAPICall(url: apiUrl, method: HttpMethod.GET, completionHandler: { (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options:[]) as! [String: Any]
                success = json["success"] as! Int
                message = json["message"] as? String
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if(success == 1){
                        self.loadModules(response: json)
                    }else{
                        self.showAlert(message: message!)
                    }
                }
            } catch let parseError as NSError {
                self.showAlert(message: parseError.description)
            }
        })
    }
    
    func loadModules(response: [String: Any]){
        moduleArr = response["modules"] as! [Any]
        moduleCount = moduleArr.count
        progressHUD.hide()
        if #available(iOS 10.0, *) {
            refreshControl.endRefreshing()
        }
        moduleTrainingView.reloadData()
        if(isLaunch){
            isLaunch = false
            launch()
        }
    }
    
    func launchModule(sender:UIButton){
        selectedModuleSeq = sender.tag
        selectedLpSeq = (sender.titleLabel?.tag)!
        self.performSegue(withIdentifier: "LaunchModuleController", sender: nil)
    }
    
    func launch(){
        self.performSegue(withIdentifier: "LaunchModuleController", sender: nil)
    }
    func showAlert(message: String){
        let alert = UIAlertController(title: "API Exception", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let secondController = segue.destination as? LaunchModuleViewController {
            secondController.moduleSeq = selectedModuleSeq
            secondController.lpSeq = selectedLpSeq
        }
    }
    
    
    
    
}

