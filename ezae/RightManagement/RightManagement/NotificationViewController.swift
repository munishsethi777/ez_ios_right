//
//  NotificationViewController.swift
//  RightManagement
//
//  Created by Baljeet Gaheer on 29/01/18.
//  Copyright © 2018 Munish Sethi. All rights reserved.
//

import UIKit
class NotificationViewController:UIViewController,UITableViewDataSource,UITableViewDelegate{
    var notifications = [Notification]()
    var loggedInUserSeq: Int = 0
    var loggedInCompanySeq: Int = 0
    var notificationsCount: Int = 0
    var progressHUD: ProgressHUD!
    var selectedChatroomId:Int!
    var selctedChatroomName:String!
    @IBOutlet weak var notificationsTableView: UITableView!


    
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationsTableView.dataSource = self
        notificationsTableView.delegate = self
        loggedInUserSeq = PreferencesUtil.sharedInstance.getLoggedInUserSeq()
        loggedInCompanySeq = PreferencesUtil.sharedInstance.getLoggedInCompanySeq()
        progressHUD = ProgressHUD(text: "Loading")
        self.view.addSubview(progressHUD)
        getNotifications()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notificationsCount
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "NotificationTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? NotificationTableViewCell
        let notification = notifications[indexPath.row]
        cell?.notificationTitle.text = notification.title
        cell?.notificationButton.setTitle(notification.notificationType, for: UIControlState.normal)
        cell?.notificationButton.tag = indexPath.row
        cell?.notificationButton.removeTarget(self, action:#selector(nominateTraining), for: .touchUpInside)
        if(notification.notificationType == "Chatroom"){
            cell?.notificationButton.addTarget(self, action:#selector(launchChatroom), for: .touchUpInside)
        }else if(notification.notificationType == "Nominate"){
            cell?.notificationButton.addTarget(self, action:#selector(nominateTraining), for: .touchUpInside)
        }else if (notification.notificationType == "Classroom"){
            cell?.notificationButton.addTarget(self, action:#selector(goToEvents), for: .touchUpInside)
        }
        return cell!
    }
    func goToEvents(){
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
        let controller = self.tabBarController?.viewControllers![4]
        let settingController = controller?.childViewControllers[0] as! SettingsTableViewController
        settingController.isGotoEvents = true
        self.tabBarController?.selectedIndex = 4
    }
    func launchChatroom(sender:UIButton){
        let index = sender.tag
        let notification = notifications[index]
        selectedChatroomId = notification.seq
        selctedChatroomName = notification.title
        self.tabBarController?.selectedIndex = 3
        let controller = self.tabBarController?.viewControllers![3]
        let navigationController = controller?.childViewControllers[0] as! UINavigationController
        let chatController = navigationController.viewControllers[0] as! ChatViewController
        chatController.selectedChatroomId = selectedChatroomId
        chatController.selctedChatroomName = selctedChatroomName
        chatController.isCalledFromDashboard = true
        self.tabBarController?.selectedIndex = 3
        
    }
    func nominateTraining(sender:UIButton){
        let index = sender.tag
        let notification = notifications[index]
        let tSeq = notification.seq
        let lpSeq = 0
        let refreshAlert = UIAlertController(title: "Nominate", message: StringConstants.NOMINATE_TRAINING_CONFIRM, preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            self.excuteNominateTraining(trainingSeq:tSeq,lpSeq: lpSeq)
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        present(refreshAlert, animated: true, completion: nil)
    }
    func excuteNominateTraining(trainingSeq:Int,lpSeq:Int){
        let args: [Int] = [self.loggedInUserSeq,self.loggedInCompanySeq,trainingSeq,lpSeq]
        let apiUrl: String = MessageFormat.format(pattern: StringConstants.NOMINATE_TRAINING, args: args)
        var success : Int = 0
        var message : String? = nil
        ServiceHandler.instance().makeAPICall(url: apiUrl, method: HttpMethod.GET, completionHandler: { (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options:[]) as! [String: Any]
                success = json["success"] as! Int
                message = json["message"] as? String
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if(success == 1){
                        self.getNotifications()
                    }else{
                        self.showAlert(message: message!)
                    }
                }
            } catch let parseError as NSError {
                self.showAlert(message: parseError.description)
            }
        })
    }
    func getNotifications(){
        let args: [Int] = [self.loggedInUserSeq,self.loggedInCompanySeq]
        
        let apiUrl: String = MessageFormat.format(pattern: StringConstants.GET_NOTIFICATION, args: args)
        var success : Int = 0
        var message : String? = nil
        ServiceHandler.instance().makeAPICall(url: apiUrl, method: HttpMethod.GET, completionHandler: { (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options:[]) as! [String: Any]
                success = json["success"] as! Int
                message = json["message"] as? String
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if(success == 1){
                        self.loadNotificaitons(response: json)
                    }else{
                        self.showAlert(message: message!)
                    }
                }
            } catch let parseError as NSError {
                self.showAlert(message: parseError.description)
            }
        })
    }
    
    func loadNotificaitons(response: [String: Any]){
        let notificationJsonArr = response["notifications"] as! [Any]
        self.notificationsCount = notificationJsonArr.count
        notifications = []
        for var i in 0..<notificationJsonArr.count{
            let notificationJson = notificationJsonArr[i] as! [String:Any]
            let seq = notificationJson["seq"] as! String
            let title = notificationJson["title"] as? String
            let from = notificationJson["from"] as? String
            let type = notificationJson["type"] as! String
            let status = notificationJson["status"] as? String
            let fromDate = DateUtil.sharedInstance.stringToDate(dateStr: from!)
            let fromDateInFormat = DateUtil.sharedInstance.dateToString(date: fromDate, format: DateUtil.format)
            let Detail = title! + " on " + fromDateInFormat
            var notificationType = "Nominate"
            if(type == "currentlyActiveEvent"){
                if let eventType = notificationJson["eventtype"] as? String, eventType == "chatroom"
                {
                    notificationType = "Chatroom"
                }else{
                    notificationType = "Classroom"
                }
            }else{
                if(status == "unapproved"){
                    notificationType = "Nominated"
                }
            }
            let not1 = Notification(seq:Int(seq)!,title:Detail,notificationType: notificationType)
            notifications.append(not1)
        }
        progressHUD.hide()
        self.notificationsTableView.reloadData()
    }
    
    func showAlert(message: String){
        let alert = UIAlertController(title: "MessageBox", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
