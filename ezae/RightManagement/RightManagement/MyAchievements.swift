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
        setbackround()
        //scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height:badgeTableView.frame.height+250)
        if #available(iOS 10.0, *) {
            refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(refreshDashboard), for: .valueChanged)
            scrollView.refreshControl = refreshControl
        }
        
        let gradient = CAGradientLayer()
        gradient.frame =  CGRect(origin: CGPoint.zero, size: self.pointsBackView.frame.size)
        gradient.colors = [UIColor.white.cgColor, UIColor.init(red: 110/255.0, green: 161/255.0, blue: 152/255.0, alpha: 1).cgColor]
        let shape = CAShapeLayer()
        shape.lineWidth = 4
        shape.path = UIBezierPath(rect: self.pointsBackView.bounds).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        self.pointsBackView.layer.addSublayer(gradient)
        
        let gradient2 = CAGradientLayer()
        gradient2.frame =  CGRect(origin: CGPoint.zero, size: self.scoreBackView.frame.size)
        gradient2.colors = [UIColor.white.cgColor, UIColor.init(red: 110/255.0, green: 161/255.0, blue: 152/255.0, alpha: 1).cgColor]
        let shape2 = CAShapeLayer()
        shape2.lineWidth = 4
        shape2.path = UIBezierPath(rect: self.scoreBackView.bounds).cgPath
        shape2.strokeColor = UIColor.black.cgColor
        shape2.fillColor = UIColor.clear.cgColor
        gradient2.mask = shape2
        self.scoreBackView.layer.addSublayer(gradient2)
        
        let gradient3 = CAGradientLayer()
        gradient3.frame =  CGRect(origin: CGPoint.zero, size: self.rankBackView.frame.size)
        gradient3.colors = [UIColor.white.cgColor, UIColor.init(red: 110/255.0, green: 161/255.0, blue: 152/255.0, alpha: 1).cgColor]
        let shape3 = CAShapeLayer()
        shape3.lineWidth = 4
        shape3.path = UIBezierPath(rect: self.rankBackView.bounds).cgPath
        shape3.strokeColor = UIColor.black.cgColor
        shape3.fillColor = UIColor.clear.cgColor
        gradient3.mask = shape3
        self.rankBackView.layer.addSublayer(gradient3)
        
        //pointsBackView.layer.borderWidth = 2
        //pointsBackView.layer.borderColor =  UIColor.init(red: 110/255.0, green: 161/255.0, blue: 152/255.0, alpha: 1).cgColor
        
        //scoreBackView.layer.borderWidth = 2
        //scoreBackView.layer.borderColor = UIColor.init(red: 110/255.0, green: 161/255.0, blue: 152/255.0, alpha: 1).cgColor
        
        //rankBackView.layer.borderWidth = 2
        //rankBackView.layer.borderColor = UIColor.init(red: 110/255.0, green: 161/255.0, blue: 152/255.0, alpha: 1).cgColor

    }
    func setbackround(){
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "login_back_bw_lighter.jpg")?.draw(in: self.view.bounds)
        if let image = UIGraphicsGetImageFromCurrentImageContext(){
            UIGraphicsEndImageContext()
            self.scrollView.backgroundColor = UIColor(patternImage: image)
            self.view.backgroundColor = UIColor(patternImage: image)
        }else{
            UIGraphicsEndImageContext()
            debugPrint("Image not available")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        changeNavBarColor()
    }
    override func viewDidAppear(_ animated: Bool) {
        changeNavBarColor()
    }
    
    func changeNavBarColor(){
        self.navigationController?.navigationBar.tintColor = .black
        let image = UIImage.imageFromColor(color: UIColor(red: 110/255.0, green: 143/255.0, blue: 130/255.0, alpha: 0.5))
        self.navigationController?.navigationBar.setBackgroundImage(image, for: .default)
        self.navigationController?.navigationBar.isTranslucent = true
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


