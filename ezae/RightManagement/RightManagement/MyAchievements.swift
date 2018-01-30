//
//  MyAchievements.swift
//  RightManagement
//
//  Created by Baljeet Gaheer on 29/11/17.
//  Copyright © 2017 Munish Sethi. All rights reserved.
//

import UIKit

class
MyAchievements:UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    @IBOutlet weak var pointsBackView: UIView!
    @IBOutlet weak var scoreBackView: UIView!
    @IBOutlet weak var rankBackView: UIView!
    @IBOutlet weak var badgeTableView: UITableView!
    var loggedInUserSeq: Int = 0
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    var loggedInCompanySeq: Int = 0
    var badges = [Badge]()
    var badgesCount: Int = 0
    var progressHUD: ProgressHUD!
    var refreshControl:UIRefreshControl!
    override func viewDidLoad() {
        self.loggedInUserSeq =  PreferencesUtil.sharedInstance.getLoggedInUserSeq()
        self.loggedInCompanySeq =  PreferencesUtil.sharedInstance.getLoggedInCompanySeq()
        badgeTableView.delegate = self
        badgeTableView.dataSource = self
        progressHUD = ProgressHUD(text: "Loading")
        self.view.addSubview(progressHUD)
        getMyAchievements()
        getBadges()
        //scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height:badgeTableView.frame.height+250)
        if #available(iOS 10.0, *) {
            refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(refreshDashboard), for: .valueChanged)
            scrollView.refreshControl = refreshControl
        }
        
        pointsBackView.layer.cornerRadius = 8
        pointsBackView.layer.borderWidth = 1
        pointsBackView.layer.borderColor = UIColor.lightGray.cgColor
        pointsBackView.layer.shadowColor = UIColor.lightGray.cgColor
        pointsBackView.layer.shadowOffset = CGSize(width: 1, height: 1)
        pointsBackView.layer.shadowOpacity = 0.5
        pointsBackView.layer.shadowRadius = 4.0
        
        scoreBackView.layer.cornerRadius = 8
        scoreBackView.layer.borderWidth = 1
        scoreBackView.layer.borderColor = UIColor.lightGray.cgColor
        scoreBackView.layer.shadowColor = UIColor.lightGray.cgColor
        scoreBackView.layer.shadowOffset = CGSize(width: 1, height: 1)
        scoreBackView.layer.shadowOpacity = 0.5
        scoreBackView.layer.shadowRadius = 4.0
        
        rankBackView.layer.cornerRadius = 8
        rankBackView.layer.borderWidth = 1
        rankBackView.layer.borderColor = UIColor.lightGray.cgColor
        rankBackView.layer.shadowColor = UIColor.lightGray.cgColor
        rankBackView.layer.shadowOffset = CGSize(width: 1, height: 1)
        rankBackView.layer.shadowOpacity = 0.5
        rankBackView.layer.shadowRadius = 4.0

    }
    func refreshDashboard(refreshControl: UIRefreshControl) {
        getMyAchievements()
        getBadges()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.badgesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "BadgeTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? BadgeTableViewCell
        let badge = badges[indexPath.row]
        cell?.badgeTitleLabel.text = badge.title
        cell?.badgeDetailImage.text = badge.detail
        cell?.badgeDateLabel.text = badge.date
        let imagePath = StringConstants.WEB_API_URL + badge.imagepath
        if let url = NSURL(string: imagePath) {
            if let data = NSData(contentsOf: url as URL) {
                cell?.badgeImageView.image = UIImage(data: data as Data)
            }
        }
        return cell!
    }
    
    func getMyAchievements(){
        let args: [Int] = [self.loggedInUserSeq,self.loggedInCompanySeq]
        let apiUrl: String = MessageFormat.format(pattern: StringConstants.GET_ACHIEVEMENTS, args: args)
        var success : Int = 0
        var message : String? = nil
        ServiceHandler.instance().makeAPICall(url: apiUrl, method: HttpMethod.GET, completionHandler: { (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options:[]) as! [String: Any]
                success = json["success"] as! Int
                message = json["message"] as? String
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if(success == 1){
                        self.loadAchievementData(response: json)
                    }else{
                        self.showAlert(message: message!)
                    }
                }
            } catch let parseError as NSError {
                self.showAlert(message: parseError.description)
            }
        })
    }
    
    
    func getBadges(){
        let args: [Int] = [self.loggedInUserSeq,self.loggedInCompanySeq]
        let apiUrl: String = MessageFormat.format(pattern: StringConstants.GET_ACHIEVEMENT_BADGES, args: args)
        var success : Int = 0
        var message : String? = nil
        ServiceHandler.instance().makeAPICall(url: apiUrl, method: HttpMethod.GET, completionHandler: { (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options:[]) as! [String: Any]
                success = json["success"] as! Int
                message = json["message"] as? String
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if(success == 1){
                        self.loadBadges(response: json)
                    }else{
                        self.showAlert(message: message!)
                    }
                }
            } catch let parseError as NSError {
                self.showAlert(message: parseError.description)
            }
        })
    }
    
    func loadAchievementData(response: [String: Any]){
        let responseJson = response["dashboardData"] as! [String:Any]
        let totalScore = responseJson["totalScores"] as! Int
        var userRankStr = responseJson["userRank"] as? Int
        if(userRankStr == nil){
            userRankStr = 0
        }
        let trainings = responseJson["pendingTrainings"] as! [String: Any]
        let maxScore = trainings["maxScore"] as! Int
        let points = responseJson["points"] as! Int
        let totalScoreStr = String(totalScore) + "/" + String(maxScore)
        rankLabel.text = String(userRankStr!)
        pointsLabel.text = String(points)
        scoreLabel.text = totalScoreStr
    }
    
    func loadBadges(response: [String: Any]){
        let badgesJsonArr = response["badges"] as! [Any]
        badgesCount = badgesJsonArr.count
        for i in 0..<badgesJsonArr.count{
            let badgeJson = badgesJsonArr[i] as! [String:Any]
            let title = badgeJson["title"] as! String
            let detail = badgeJson["detail"] as! String
            let date = badgeJson["date"] as! String
            let imagePath = badgeJson["imagepath"] as! String
            let badge = Badge(title: title, detail: detail, date: date, imagepath: imagePath)
            badges.append(badge)
        }
        progressHUD.hide()
        badgeTableView.reloadData()
        badgeTableView.frame.size.height = CGFloat(badgesCount*100)
        scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height:badgeTableView.frame.size.height + 200)

        if #available(iOS 10.0, *){
            refreshControl.endRefreshing()
        }
    }
    
    func showAlert(message: String){
        let alert = UIAlertController(title: "API Exception", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
