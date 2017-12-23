//
//  TrainingViewController.swift
//  RightManagement
//
//  Created by Baljeet Gaheer on 02/12/17.
//  Copyright © 2017 Munish Sethi. All rights reserved.
//

import UIKit
class TrainingViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    var loggedInUserSeq: Int = 0
    var loggedInCompanySeq: Int = 0
    var lpDetailCount: Int = 0
    var lpModuleArr: [[String]] = []
    var lpDetailArr: [Any] = []
    var selectedModuleSeq: Int = 0
    var selectedLpSeq: Int = 0
    @IBOutlet weak var trainingTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
       trainingTableView.delegate = self
       trainingTableView.dataSource = self
       self.loggedInUserSeq =  PreferencesUtil.sharedInstance.getLoggedInUserSeq()
       self.loggedInCompanySeq =  PreferencesUtil.sharedInstance.getLoggedInCompanySeq()
       getLearningPlanAndModules()
       navigationItem.leftBarButtonItem = UIBarButtonItem(title: "< Back", style: .plain, target: self, action: #selector(backAction))
    }
    func backAction(){
        //print("Back Button Clicked")
        dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let lpJsonArr = lpDetailArr[section] as! [String: Any]
        let lpModuleArr = lpJsonArr["modules"] as! [Any]
        return  lpModuleArr.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return lpModuleArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "TrainingTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TrainingTableViewCell
        let section: Int = indexPath.section
        let row: Int = indexPath.row
        let lpJsonArr = lpDetailArr[section] as! [String: Any]
        let moduleJsonArr = lpJsonArr["modules"] as! [Any]
        let moduleJson = moduleJsonArr[row] as! [String: Any]
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
        moduleImageUrl = StringConstants.IMAGE_URL + "modules/" + moduleImageUrl!
        if let url = NSURL(string: moduleImageUrl!) {
            if let data = NSData(contentsOf: url as URL) {
                cell?.moduleImageView.image = UIImage(data: data as Data)
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
        if(progress > 0 && progress < 100){
            buttonTitle = "In Progress"
        }
        if(progress == 100){
            buttonTitle = "Review"
        }
        cell?.launchModuleButton.setTitle(buttonTitle, for: .normal)
        cell?.launchModuleButton.tag = seq
        cell?.launchModuleButton.titleLabel?.tag = lpSeq
        cell?.launchModuleButton.addTarget(self, action:#selector(launchModule), for: .touchUpInside)
        if(moduleType == "quiz" && rank > 0){
            cell?.leaderboardLabel.text = String(rank) + "\nLeaderboard"
        }else{
            cell?.leaderboardLabel.isHidden = true
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int)->String?{
        let lpJsonArr = lpDetailArr[section] as! [String: Any]
        let sectionHeader = lpJsonArr["title"] as? String
        return sectionHeader
    }
    
    
    func launchModule(sender:UIButton){
        selectedModuleSeq = sender.tag
        selectedLpSeq = (sender.titleLabel?.tag)!
        self.performSegue(withIdentifier: "LaunchModuleController", sender: nil)
    }
   
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView =  UIView.init(frame: CGRect(x: 5, y: 5, width: 40, height: 40))
        //headerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200)
        headerView.backgroundColor = UIColor.gray
        let lpJsonArr = lpDetailArr[section] as! [String: Any]
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
                        self.loadLearningPlanAndModule(response: json)
                    }else{
                        self.showAlert(message: message!)
                    }
                }
            } catch let parseError as NSError {
                self.showAlert(message: parseError.description)
            }
        })
    }
    
    func loadLearningPlanAndModule(response: [String: Any]){
        lpDetailArr = response["learningPlanDetails"] as! [Any]
        lpDetailCount = lpDetailArr.count
        for var i in (0..<lpDetailArr.count).reversed(){
            var jsonArr: [String] = []
            let lpDetailJson = lpDetailArr[i] as! [String: Any]
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
        }
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
