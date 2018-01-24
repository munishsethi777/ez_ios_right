//
//  DashboardViewController.swift
//  RightManagement
//
//  Created by Munish Sethi on 22/01/18.
//  Copyright © 2018 Munish Sethi. All rights reserved.
//

import UIKit
class DashboardViewController:UIViewController{
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var notificationsView: UIView!
    @IBOutlet weak var trainingsView: UIView!
    @IBOutlet weak var messagesView: UIView!
    @IBOutlet weak var achievementsView: UIView!
    @IBOutlet weak var notesView: UIView!
    @IBOutlet weak var eventsView: UIView!
    @IBOutlet weak var chatroomsView: UIView!
    @IBOutlet weak var updateProfileView: UIView!
    
    override func viewDidLoad() {
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
        
        
    }

}
