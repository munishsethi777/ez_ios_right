//
//  DashboardViewController.swift
//  RightManagement
//
//  Created by Munish Sethi on 22/01/18.
//  Copyright © 2018 Munish Sethi. All rights reserved.
//

import UIKit
import SSCalendar
class DashboardViewController:UIViewController{
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var notificationsView: UIView!
    @IBOutlet weak var trainingsView: UIView!
    @IBOutlet weak var messagesView: UIView!
    @IBOutlet weak var achievementsView: UIView!
    @IBOutlet weak var notesView: UIView!
    @IBOutlet weak var eventsView: UIView!
    @IBOutlet weak var chatroomsView: UIView!
    @IBOutlet weak var updateProfileView: UIView!
    @IBOutlet weak var changePasswordView: UIView!
    @IBOutlet weak var logoutView: UIView!
    
    @IBOutlet weak var messagesCount: UILabel!
    @IBOutlet weak var pendingLpCount: UILabel!
    @IBOutlet weak var notificationsCount: UILabel!
    
    @IBAction func trainingsButton(_ sender: Any) {
        self.tabBarController?.selectedIndex = 1
    }
    @IBOutlet weak var points: UILabel!
    
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var userProfileLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBAction func messagesButtonAction(_ sender: Any) {
        self.tabBarController?.selectedIndex = 3
    }
    
    @IBAction func chatroomsAction(_ sender: Any) {
        self.tabBarController?.selectedIndex = 4
    }
   
    
//    @IBAction func notificationAction(_ sender: Any) {
//        let controller = self.tabBarController?.viewControllers![4]
//        let settingController = controller?.childViewControllers[0] as! SettingsTableViewController
//        settingController.isGoToNotification = true
//        self.tabBarController?.selectedIndex = 4
//    }
//    @IBAction func achievementAction(_ sender: Any) {
//        let controller = self.tabBarController?.viewControllers![4]
//        let settingController = controller?.childViewControllers[0] as! SettingsTableViewController
//        settingController.isGotoAchivement = true
//        self.tabBarController?.selectedIndex = 4
//    }
    
//    @IBAction func notesAction(_ sender: Any) {
//        let controller = self.tabBarController?.viewControllers![4]
//        let settingController = controller?.childViewControllers[0] as! SettingsTableViewController
//        settingController.isGoToNotes = true
//        self.tabBarController?.selectedIndex = 4
//    }
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
    
    @IBAction func logoutAction(_ sender: Any) {
        logout()
    }
    
    @IBAction func eventAction(_ sender: Any) {
        getEvents()
    }
    
//    @IBAction func profileAction(_ sender: Any) {
//        let controller = self.tabBarController?.viewControllers![4]
//        let settingController = controller?.childViewControllers[0] as! SettingsTableViewController
//        settingController.isGoToProfile = true
//        self.tabBarController?.selectedIndex = 4
//    }
    var loggedInUserSeq:Int = 0
    var loggedInCompanySeq:Int = 0
    var  progressHUD: ProgressHUD!
    var refreshControl:UIRefreshControl!
    override func viewDidLoad() {
        loggedInUserSeq = PreferencesUtil.sharedInstance.getLoggedInUserSeq()
        loggedInCompanySeq = PreferencesUtil.sharedInstance.getLoggedInCompanySeq()
        userImageView.layer.borderWidth = 3
        userImageView.layer.borderColor = UIColor.white.cgColor
        userImageView.layer.cornerRadius = userImageView.frame.size.width / 2;
        userImageView.clipsToBounds = true
        
        notificationsView.layer.cornerRadius = 2
        notificationsView.layer.borderWidth = 0.5
        notificationsView.layer.borderColor = UIColor.lightGray.cgColor
        notificationsView.layer.shadowColor = UIColor.lightGray.cgColor
        notificationsView.layer.shadowOffset = CGSize(width: 1, height: 1)
        notificationsView.layer.shadowOpacity = 0.5
        notificationsView.layer.shadowRadius = 4.0
        
        messagesView.layer.cornerRadius = 2
        messagesView.layer.borderWidth = 0.5
        messagesView.layer.borderColor = UIColor.lightGray.cgColor
        messagesView.layer.shadowColor = UIColor.lightGray.cgColor
        messagesView.layer.shadowOffset = CGSize(width: 1, height: 1)
        messagesView.layer.shadowOpacity = 0.5
        messagesView.layer.shadowRadius = 4.0
        
        chatroomsView.layer.cornerRadius = 2
        chatroomsView.layer.borderWidth = 0.5
        chatroomsView.layer.borderColor = UIColor.lightGray.cgColor
        chatroomsView.layer.shadowColor = UIColor.lightGray.cgColor
        chatroomsView.layer.shadowOffset = CGSize(width: 1, height: 1)
        chatroomsView.layer.shadowOpacity = 0.5
        chatroomsView.layer.shadowRadius = 4.0
        
        updateProfileView.layer.cornerRadius = 2
        updateProfileView.layer.borderWidth = 0.5
        updateProfileView.layer.borderColor = UIColor.lightGray.cgColor
        updateProfileView.layer.shadowColor = UIColor.lightGray.cgColor
        updateProfileView.layer.shadowOffset = CGSize(width: 1, height: 1)
        updateProfileView.layer.shadowOpacity = 0.5
        updateProfileView.layer.shadowRadius = 4.0
        
        notesView.layer.cornerRadius = 2
        notesView.layer.borderWidth = 0.5
        notesView.layer.borderColor = UIColor.lightGray.cgColor
        notesView.layer.shadowColor = UIColor.lightGray.cgColor
        notesView.layer.shadowOffset = CGSize(width: 1, height: 1)
        notesView.layer.shadowOpacity = 0.5
        notesView.layer.shadowRadius = 4.0
        
        trainingsView.layer.cornerRadius = 2
        trainingsView.layer.borderWidth = 0.5
        trainingsView.layer.borderColor = UIColor.lightGray.cgColor
        trainingsView.layer.shadowColor = UIColor.lightGray.cgColor
        trainingsView.layer.shadowOffset = CGSize(width: 1, height: 1)
        trainingsView.layer.shadowOpacity = 0.5
        trainingsView.layer.shadowRadius = 4.0
        
        eventsView.layer.cornerRadius = 2
        eventsView.layer.borderWidth = 0.5
        eventsView.layer.borderColor = UIColor.lightGray.cgColor
        eventsView.layer.shadowColor = UIColor.lightGray.cgColor
        eventsView.layer.shadowOffset = CGSize(width: 1, height: 1)
        eventsView.layer.shadowOpacity = 0.5
        eventsView.layer.shadowRadius = 4.0
        
        achievementsView.layer.cornerRadius = 2
        achievementsView.layer.borderWidth = 0.5
        achievementsView.layer.borderColor = UIColor.lightGray.cgColor
        achievementsView.layer.shadowColor = UIColor.lightGray.cgColor
        achievementsView.layer.shadowOffset = CGSize(width: 1, height: 1)
        achievementsView.layer.shadowOpacity = 0.5
        achievementsView.layer.shadowRadius = 4.0
        
        changePasswordView.layer.cornerRadius = 2
        changePasswordView.layer.borderWidth = 0.5
        changePasswordView.layer.borderColor = UIColor.lightGray.cgColor
        changePasswordView.layer.shadowColor = UIColor.lightGray.cgColor
        changePasswordView.layer.shadowOffset = CGSize(width: 1, height: 1)
        changePasswordView.layer.shadowOpacity = 0.5
        changePasswordView.layer.shadowRadius = 4.0
        
        logoutView.layer.cornerRadius = 2
        logoutView.layer.borderWidth = 0.5
        logoutView.layer.borderColor = UIColor.lightGray.cgColor
        logoutView.layer.shadowColor = UIColor.lightGray.cgColor
        logoutView.layer.shadowOffset = CGSize(width: 1, height: 1)
        logoutView.layer.shadowOpacity = 0.5
        logoutView.layer.shadowRadius = 4.0
        
        scrollView.isScrollEnabled = true
        scrollView.contentSize.height = 880
        self.topView.backgroundColor = UIColor(patternImage: UIImage(named: "topview_back_blue.jpg")!)
        progressHUD = ProgressHUD(text: "Loading")
        self.view.addSubview(progressHUD)
        getDashboardCounts()
        getDashboardStates()
        synchCompanyUsers()
        if #available(iOS 10.0, *) {
            refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(refreshDashboard), for: .valueChanged)
            scrollView.refreshControl = refreshControl
        }
        
    }
    func refreshDashboard(refreshControl: UIRefreshControl) {
        getDashboardCounts()
        getDashboardStates()
    }
    func populateUserInfoFromLocal(){
       let user =  UserMgr.sharedInstance.getUserByUserSeq(userSeq: loggedInUserSeq)
       let userName = user?.fullname
       var userImageName = user?.imagename
       if(userImageName == nil){
           userImageName = "dummy.jpg"
       }
       let imageUrl = StringConstants.USER_IMAGE_URL + userImageName!
       let userProfiles = user?.profiles
       if let url = NSURL(string: imageUrl) {
            if let data = NSData(contentsOf: url as URL) {
                userImageView.image = UIImage(data: data as Data)
            }
        }
        userNameLabel.text = userName
        userProfileLabel.text = userProfiles
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       self.scrollView.backgroundColor = UIColor(patternImage: UIImage(named: "right_back_blue.jpg")!)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        handleNotificationData()
    }

    
   
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    private func handleNotificationData(){
        let isNotificationState = PreferencesUtil.sharedInstance.isNotificationState()
        if(isNotificationState){
            let data = PreferencesUtil.sharedInstance.getNotificationData()
            let entityType = data["entityType"]
            if(entityType == "module"){
                self.tabBarController?.selectedIndex = 1
            }else{
                PreferencesUtil.sharedInstance.resetNotificationData()
                let controller = self.tabBarController?.viewControllers![4]
                let settingController = controller?.childViewControllers[0] as! SettingsTableViewController
                settingController.isGotoAchivement = true
                self.tabBarController?.selectedIndex = 4
            }
        }
    }
    func synchCompanyUsers(){
        let args: [Int] = [self.loggedInUserSeq,self.loggedInCompanySeq]
        let apiUrl: String = MessageFormat.format(pattern: StringConstants.SYNCH_USERS, args: args)
        var success : Int = 0
        var message : String? = nil
        ServiceHandler.instance().makeAPICall(url: apiUrl, method: HttpMethod.GET, completionHandler: { (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options:[]) as! [String: Any]
                success = json["success"] as! Int
                message = json["message"] as? String
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if(success == 1){
                        CompanyUserMgr.sharedInstance.saveUsersFromResponse(response: json)
                    }else{
                        self.showAlert(message: message!)
                    }
                }
            } catch let parseError as NSError {
                self.showAlert(message: parseError.description)
            }
        })
    }
    fileprivate func getEvents(){
        progressHUD = ProgressHUD(text: "Loading")
        self.view.addSubview(progressHUD)
        let args: [Int] = [self.loggedInUserSeq,self.loggedInCompanySeq]
        let apiUrl: String = MessageFormat.format(pattern: StringConstants.GET_EVENTS, args: args)
        var success : Int = 0
        var message : String? = nil
        ServiceHandler.instance().makeAPICall(url: apiUrl, method: HttpMethod.GET, completionHandler: { (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options:[]) as! [String: Any]
                success = json["success"] as! Int
                message = json["message"] as? String
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if(success == 1){
                        self.progressHUD.hide()
                        self.populateEvents(response: json)
                    }else{
                        self.showAlert(message: message!)
                    }
                }
            } catch let parseError as NSError {
                self.showAlert(message: parseError.description)
            }
        })
    }
    
    func populateEvents(response:[String: Any]){
        let annualViewController = SSCalendarAnnualViewController(events: generateEvents(eventsJson: response))
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController!.pushViewController(annualViewController!, animated: true)
    }
    
    fileprivate func generateEvents(eventsJson:[String:Any]) -> [SSEvent] {
        var events: [SSEvent] = []
        let eventsArr = eventsJson["chatrooms"] as! [Any]
        for i in 0..<eventsArr.count{
            let eventJson = eventsArr[i] as! [String: Any]
            let title = eventJson["title"] as! String
            let detail = eventJson["detail"] as! String
            let startDateStr = eventJson["from"] as! String
            let endDateStr = eventJson["to"] as! String
            let event = SSEvent()
            let startDate = DateUtil.sharedInstance.stringToDate(dateStr: startDateStr)
            event.startDate = startDate
            event.startTime = DateUtil.sharedInstance.dateToString(date: startDate, format: DateUtil.time_format)
            let endDate = DateUtil.sharedInstance.stringToDate(dateStr: endDateStr)
            let dateDiffArr = DateUtil.sharedInstance.getDatesDiff(start: startDate, end: endDate)
            event.name = title
            event.desc = detail
            events.append(event)
            if(!dateDiffArr.isEmpty){
                for date in dateDiffArr{
                    let eventN = SSEvent()
                    eventN.name = event.name
                    eventN.desc = event.desc
                    eventN.startTime = event.startTime
                    eventN.startDate = date
                    events.append(eventN)
                }
            }
        }
        return events
    }
    func getDashboardCounts(){
        let args: [Int] = [self.loggedInUserSeq,self.loggedInCompanySeq]
        let apiUrl: String = MessageFormat.format(pattern: StringConstants.GET_COUNTS, args: args)
        var success : Int = 0
        var message : String? = nil
        ServiceHandler.instance().makeAPICall(url: apiUrl, method: HttpMethod.GET, completionHandler: { (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options:[]) as! [String: Any]
                success = json["success"] as! Int
                message = json["message"] as? String
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if(success == 1){
                        self.populateDashboardCounts(response: json)
                    }else{
                        self.showAlert(message: message!)
                    }
                }
            } catch let parseError as NSError {
                self.showAlert(message: parseError.description)
            }
        })
    }
    func getDashboardStates(){
        let args: [Int] = [self.loggedInUserSeq,self.loggedInCompanySeq]
        let apiUrl: String = MessageFormat.format(pattern: StringConstants.GET_DASHBOARD_COUNTS, args: args)
        var success : Int = 0
        var message : String? = nil
        ServiceHandler.instance().makeAPICall(url: apiUrl, method: HttpMethod.GET, completionHandler: { (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options:[]) as! [String: Any]
                success = json["success"] as! Int
                message = json["message"] as? String
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if(success == 1){
                        self.populateDashboardStats(response: json)
                    }else{
                        self.showAlert(message: message!)
                    }
                }
            } catch let parseError as NSError {
                self.showAlert(message: parseError.description)
            }
        })
    }
    func populateDashboardCounts(response: [String: Any]){
        let responseJson = response["dashboardCounts"] as! [String:Any]
        let pendingLpCount = responseJson["pendingLpCount"] as! Int
        let notificationCount = responseJson["notificationCount"] as! Int
        let mesasgeCount = responseJson["messages"] as! Int
        if(pendingLpCount > 0){
            self.pendingLpCount.text =  "+" + String(pendingLpCount)
        }
        if(notificationCount > 0){
            self.notificationsCount.text = "+" + String(notificationCount)
        }
        if(mesasgeCount > 0){
            self.messagesCount.text = "+" + String(mesasgeCount)
        }
        progressHUD.hide()
    }
    
    func populateDashboardStats(response: [String: Any]){
        let responseJson = response["dashboardData"] as! [String:Any]
        let totalScore = responseJson["totalScores"] as! Int
        let point = responseJson["points"] as! Int
        let pendingTrainings = responseJson["pendingTrainings"] as! [String:Any]
        let maxScore = pendingTrainings["maxScore"] as! Int
        var userRankStr = responseJson["userRank"] as? Int
        if(userRankStr == nil){
            userRankStr = 0
        }
        let pendingCount = pendingTrainings["pendingCount"] as! Int
        let totalScoreStr = String(totalScore) + "/" + String(maxScore)
        rankLabel.text = String(userRankStr!)
        scoreLabel.text = totalScoreStr
        self.points.text = String(point)
        progressHUD.hide()
        populateUserInfoFromLocal()
        if #available(iOS 10.0, *) {
            self.refreshControl.endRefreshing()
        }
    }
    
    func showAlert(message: String){
        let alert = UIAlertController(title: "API Exception", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
