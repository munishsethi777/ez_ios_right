//
//  DashboardVC.swift
//  RightManagement
//
//  Created by Munish Sethi on 10/10/17.
//  Copyright © 2017 Munish Sethi. All rights reserved.
//

import UIKit

class DashboardVC:UIViewController,UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate{
    
    @IBOutlet weak var rankView: UIView!
    @IBOutlet weak var scoreView: UIView!
    @IBOutlet weak var pointsView: UIView!
    @IBOutlet weak var trainingView: UIView!
    @IBOutlet weak var notificationsTableView: UITableView!
    @IBOutlet weak var activeLearningPlanCollectionView: UICollectionView!
   
    var notifications = [Notification]()
    var activeLearningPlans = [ActiveLearningPlan]()
    
    override func viewDidLoad() {
        rankView.layer.cornerRadius = 8
        scoreView.layer.cornerRadius = 8
        pointsView.layer.cornerRadius = 8
        trainingView.layer.cornerRadius = 8
        
        notificationsTableView.delegate = self
        notificationsTableView.dataSource = self
        
        activeLearningPlanCollectionView.delegate = self
        activeLearningPlanCollectionView.dataSource = self
        //activeLearningPlanCollectionView.register(ActiveLearningPlanCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "ActiveLearningPlanCollectionViewCell")
        loadNotificaitons()
        loadActiveLearningPlans();
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
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
        return cell!
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 3
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdentifier = "ActiveLearningPlanCollectionViewCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? ActiveLearningPlanCollectionViewCell
        let learningPlan = activeLearningPlans[indexPath.row]
        cell?.learningPlanTitle.text = learningPlan.learningPlanName
        cell?.learningPlanPercent.text = String(learningPlan.percentageCompleted)
        return cell!

    }
    
    func loadNotificaitons(){
        let not1 = Notification(seq:1,title:"Selft Nominate for the new class room training on 1st Oct.",notificationType:"nomination")
        let not2 = Notification(seq:2,title:"New Chatroom has started follow right now.",notificationType:"chatroom")
        let not3 = Notification(seq:3,title:"New Chatroom has started follow right now.",notificationType:"chatroom")
        let not4 = Notification(seq:4,title:"New Chatroom has started follow right now.",notificationType:"chatroom")
        let not5 = Notification(seq:5,title:"New Chatroom has started follow right now.",notificationType:"chatroom")
        notifications += [not1,not2,not3,not4,not5]
    }
    func loadActiveLearningPlans(){
        let alp1 = ActiveLearningPlan(learningPlanSeq: 1, learningPlanName: "First Training Plan", percentageCompleted: 20)
        let alp2 = ActiveLearningPlan(learningPlanSeq: 1, learningPlanName: "First Training Plan", percentageCompleted: 20)
        let alp3 = ActiveLearningPlan(learningPlanSeq: 1, learningPlanName: "First Training Plan", percentageCompleted: 20)
        activeLearningPlans += [alp1,alp2,alp3]
    }
    
}
