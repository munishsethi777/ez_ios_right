//
//  TrainingViewController.swift
//  RightManagement
//
//  Created by Baljeet Gaheer on 02/12/17.
//  Copyright © 2017 Munish Sethi. All rights reserved.
//

import UIKit
import Foundation
class TrainingViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    var loggedInUserSeq: Int = 0
    var loggedInCompanySeq: Int = 0
    var lpDetailCount: Int = 0
    var lpModuleArr: [[String]] = []
    var lpDetailArr: [Any] = []
    var selectedModuleSeq: Int = 0
    var selectedLpSeq: Int = 0
    var refreshControl:UIRefreshControl!
    var  progressHUD: ProgressHUD!
    var totalModuleCount:Int = 0
    var learningPlanJson:[String: Any] = [:]
    var cell:TrainingTableViewCell!
    
    @IBAction func backTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    var cache:NSCache<AnyObject, AnyObject>!
    @IBOutlet weak var trainingTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
       cache = NSCache()
       trainingTableView.delegate = self
       trainingTableView.dataSource = self
       self.loggedInUserSeq =  PreferencesUtil.sharedInstance.getLoggedInUserSeq()
       self.loggedInCompanySeq =  PreferencesUtil.sharedInstance.getLoggedInCompanySeq()
       progressHUD = ProgressHUD(text: "Loading")
       loadLearningPlanAndModule()
       navigationItem.leftBarButtonItem = UIBarButtonItem(title: "< Back", style: .plain, target: self, action: #selector(backAction))
        if #available(iOS 10.0, *) {
            refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(refreshView), for: .valueChanged)
            trainingTableView.refreshControl = refreshControl
        }
        
        self.view.addSubview(progressHUD)
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    func refreshView(refreshControl: UIRefreshControl) {
        cache = NSCache()
        getLearningPlanAndModules()
    }
    
    func backAction(){
        //print("Back Button Clicked")
        dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //let lpJsonArr = lpDetailArr[section] as! [String: Any]
        let lpModuleArr = learningPlanJson["modules"] as! [Any]
        return  lpModuleArr.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
  
    
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row: Int = indexPath.row
        let section: Int = indexPath.section
        let lpJsonArr = learningPlanJson //lpDetailArr[section] as! [String: Any]
        let moduleJsonArr = learningPlanJson["modules"] as! [Any]
        let moduleJson = moduleJsonArr[row] as! [String: Any]
        let moduleSeq = moduleJson["seq"] as! String
        let cellIdentifier = "TrainingTableViewCell"
        cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TrainingTableViewCell
        var moduleImageUrl = moduleJson["imagepath"] as? String
        var lpSeqStr = moduleJson["learningPlanSeq"] as? String
        var seqStr = moduleJson["seq"] as? String
        if(lpSeqStr == nil){
            lpSeqStr = "0"
        }
        if(seqStr == nil){
            seqStr = "0"
        }
        var lpSeq = Int(lpSeqStr!)!
        var seq = Int(seqStr!)!
        var progressStr = moduleJson["progress"] as? String
        var moduleType = moduleJson["moduletype"] as! String
        var leaderboardRankStr = moduleJson["leaderboard"] as? String
        if(leaderboardRankStr == nil){
            leaderboardRankStr = "0"
        }
        let rank: Int = Int(leaderboardRankStr!)!
        if(progressStr == nil){
            progressStr = "0"
        }
        let progress: Int = Int(progressStr!)!
        if(moduleImageUrl == nil || (moduleImageUrl?.isEmpty)!){
            moduleImageUrl = "dummy.jpg"
        }
        
        if (self.cache.object(forKey: moduleSeq as AnyObject) != nil){
            cell.moduleImageView?.image = self.cache.object(forKey: moduleSeq as AnyObject) as? UIImage
        }else {
            moduleImageUrl = StringConstants.IMAGE_URL + "modules/" + moduleImageUrl!
            if let url = NSURL(string: moduleImageUrl!) {
                if let data = NSData(contentsOf: url as URL) {
                    let img = UIImage(data: data as Data)
                    cell?.moduleImageView.image = img
                    self.cache.setObject(img!, forKey: moduleSeq as AnyObject)
                }
            }
        }
        cell?.moduleTitle.text = moduleJson["title"] as? String
        var points = moduleJson["points"] as? String
        if(points == nil){
            points = "0"
        }
        var score = moduleJson["score"] as? String
        if(score == nil){
            score = "0"
        }
        cell?.pointLabel.text = points
        cell?.scoreLabel.text = score
        var buttonTitle: String = "Launch"
        let isLocalProgressExists:Bool = ModuleProgressMgr.sharedInstance.isProgressForModule(moduleSeq: seq, learningPlanSeq: lpSeq)
        if((progress > 0 && progress < 100) || (progress < 100 && isLocalProgressExists)){
            buttonTitle = "In Progress"
        }
        if(progress == 100){
            buttonTitle = "Review"
        }
        let isLockSequence = lpJsonArr["lockSequence"] as! Bool;
        cell?.launchModuleButton.isEnabled = true
        if(row > 0 && isLockSequence){
            let previousModuleJson = moduleJsonArr[row-1] as! [String: Any]
            let lastProgressStr = previousModuleJson["progress"] as? String
            var lastProgress = 0;
            if(lastProgressStr != nil){
                lastProgress =  Int(lastProgressStr!)!
            }
            if(lastProgress < 100){
                cell?.launchModuleButton.isEnabled = false
            }
        }
        cell?.launchModuleButton.setTitle(buttonTitle, for: .normal)
        cell?.launchModuleButton.tag = seq
        cell?.launchModuleButton.titleLabel?.tag = lpSeq
        cell?.launchModuleButton.addTarget(self, action:#selector(launchModule), for: .touchUpInside)
        if(moduleType == "quiz" && rank > 0 && progress == 100){
            cell?.leaderboardLabel.text = String(rank) + "\nLeaderboard"
        }else{
            cell?.leaderboardLabel.isHidden = true
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int)->String?{
       // let lpJsonArr = lpDetailArr[section] as! [String: Any]
        let sectionHeader = learningPlanJson["title"] as? String
        return sectionHeader
    }
    
    
    func launchModule(sender:UIButton){
        selectedModuleSeq = sender.tag
        selectedLpSeq = (sender.titleLabel?.tag)!
        self.performSegue(withIdentifier: "LaunchModuleController", sender: nil)
    }
    var headerArr:[Int:UIView] = [:]
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if(headerArr[section] != nil){
            return headerArr[section]!
        }
        let headerView =  UIView.init(frame: CGRect(x: 5, y: 5, width: 40, height: 40))
        //headerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200)
        headerView.backgroundColor = UIColor.gray
        let lpJsonArr = learningPlanJson//lpDetailArr[section] as! [String: Any]
        let percentCompleted = lpJsonArr["percentCompleted"] as! CGFloat
        let modulesJsonArr = lpJsonArr["modules"] as! [Any]
        let progress = UICircularProgressRingView.init(frame: CGRect(x: 5, y: 5, width: 40, height: 40))
        progress.setProgress(value: CGFloat(percentCompleted), animationDuration: 2)
        progress.innerRingColor = UIColor.orange
        progress.outerRingColor = UIColor.darkGray
        progress.innerRingWidth = 4
        progress.outerRingWidth = 5
        progress.font = UIFont(name: "Helvetica Neue", size: 10)!
        progress.fontColor = UIColor.white
        progress.viewStyle = 5
        for subview in headerView.subviews {
            if subview is UICircularProgressRingView || subview is UILabel {
                subview.removeFromSuperview()
            }
        }
        headerView.addSubview(progress)
        let label = UILabel.init(frame: CGRect(x: 50, y: 35, width: 80, height: 10))
        label.text = String(modulesJsonArr.count) + " Modules"
        label.font = UIFont(name: "Helvetica Neue", size: 10)
        label.textColor = UIColor.white
        headerView.addSubview(label)
        
        let sectionHeader = lpJsonArr["title"] as? String
        let headerLabel = UILabel.init(frame: CGRect(x: 50, y: 10, width: self.view.frame.width, height: 16))
        headerLabel.text = sectionHeader
        headerLabel.font = UIFont(name: "Helvetica Neue", size: 16)
        headerLabel.textColor = UIColor.white
        headerView.addSubview(headerLabel)
        headerArr[section] = headerView
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func getLearningPlanAndModules(){
        let args: [Int] = [self.loggedInUserSeq,self.loggedInCompanySeq]
        let apiUrl: String = MessageFormat.format(pattern: StringConstants.GET_LEARNING_PLAN_DETAIL, args: args)
        var success : Int = 0
        var message : String? = nil
        ServiceHandler.instance().makeAPICall(url: apiUrl, method: HttpMethod.GET, completionHandler: { (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options:[]) as! [String: Any]
                success = json["success"] as! Int
                message = json["message"] as? String
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if(success == 1){
                        self.loadLearningPlanAndModule()
                        self.progressHUD.hide()
                    }else{
                        self.showAlert(message: message!)
                    }
                }
            } catch let parseError as NSError {
                self.showAlert(message: parseError.description)
            }
        })
    }
    
    func loadLearningPlanAndModule(){
        lpDetailArr = []
        lpModuleArr = []
        lpDetailCount = 0
        trainingTableView.reloadData()
        totalModuleCount = 0
            var jsonArr: [String] = []
            let lpDetailJson = learningPlanJson
            let percentCompleted = lpDetailJson["percentCompleted"] as? Int
            let title = lpDetailJson["title"] as! String
            jsonArr.append(title)
            let modulesJsonArr = lpDetailJson["modules"] as! [Any]
            for var j in (0..<modulesJsonArr.count).reversed(){
                 let moduleJson = modulesJsonArr[j] as! [String: Any]
                 let moduleTile = moduleJson["title"] as! String
                 jsonArr.append(moduleTile)
            }
            lpModuleArr.append(jsonArr)
            totalModuleCount = totalModuleCount + modulesJsonArr.count
        if #available(iOS 10.0, *) {
            self.refreshControl.endRefreshing()
        }
        progressHUD.hide()
        trainingTableView.reloadData()
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
