//
//  StringConstants.swift
//  right
//
//  Created by Baljeet Gaheer on 13/11/17.
//  Copyright © 2017 Baljeet Gaheer. All rights reserved.
//

import Foundation
struct StringConstants {
    static let ACTION_API_URL = "http://www.ezae.in/Actions/Mobile/"
    static let WEB_API_URL = "http://www.ezae.in/"
    //User Actions
    static let LOGIN_URL = ACTION_API_URL + "UserAction.php?call=login&username={0}&password={1}&gcmid={2}"
    static let GET_DASHBOARD_COUNTS = ACTION_API_URL+"UserAction.php?call=getDashboardStats&userSeq={0}&companySeq={1}";
    static let GET_NOTIFICATION = ACTION_API_URL+"UserAction.php?call=getNotifications&userSeq={0}&companySeq={1}";
    
    static let GET_ACHIEVEMENTS = ACTION_API_URL + "UserAction.php?call=myAchievements&userSeq={0}&companyseq={1}"
    
    //Learning Plan Actions
    static let GET_LEARNING_PLAN = ACTION_API_URL + "LearningPlanAction.php?call=getLearningPlans&userSeq={0}&companySeq={1}"
    
    //Badge Actions
    static let GET_ACHIEVEMENT_BADGES = ACTION_API_URL + "BadgeAction.php?call=myAchievementMyBadges&userSeq={0}&companyseq={1}"
    
    //Message Actions
    static let GET_MESSSAGES = ACTION_API_URL + "MessageAction.php?call=getMessages&userSeq={0}&companySeq={1}"
    
    //Action Names
    static let DASHBOARD_DATA_ACTION = "getDashboardData"
    static let NOTIFICATION_ACTION = "getNotifications"
    static let LEARNING_PLAN_ACTION = "getLearningPlans"
}
