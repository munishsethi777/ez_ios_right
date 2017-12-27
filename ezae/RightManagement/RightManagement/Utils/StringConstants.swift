//
//  StringConstants.swift
//  right
//
//  Created by Baljeet Gaheer on 13/11/17.
//  Copyright © 2017 Baljeet Gaheer. All rights reserved.
//

import Foundation
struct StringConstants {
    static let SINGLE_TYPE_QUESTION = "single"
    static let MULTI_TYPE_QUESTION = "multi"
    static let LONG_TYPE_QUESTION = "longQuestion"
    static let YES_NO_TYPE_QUESTION = "yesNo"
    static let MEDIA_TYPE_QUESTION = "media"
    static let DOC_TYPE_QUESTION = "doc"
    static let LIKART_SCALE_TYPE_QUESTION = "likartScale"
    static let WEB_PAGE_TYPE_QUESTION = "web_page"
    static var ACTION_API_URL = "http://www.ezae.in/Actions/Mobile/"
    static let WEB_API_URL = "http://www.ezae.in/"
    static let IMAGE_URL = "http://www.ezae.in/images/"
    static let DOC_URL = WEB_API_URL + "docs/moduledocs/";
    static let LESSION_TYPE_MODULE = "lesson"
    static let SUBMITTED_SUCCESSFULLY = "Submitted Successfully"
    //User Actions
    static let LOGIN_URL = ACTION_API_URL + "UserAction.php?call=login&username={0}&password={1}&gcmid={2}"
    static let GET_DASHBOARD_COUNTS = ACTION_API_URL+"UserAction.php?call=getDashboardStats&userSeq={0}&companySeq={1}";
    static let GET_NOTIFICATION = ACTION_API_URL+"UserAction.php?call=getNotifications&userSeq={0}&companySeq={1}";
    static let CHANGE_PASSWORD = ACTION_API_URL + "UserAction.php?call=changePassword&userSeq={0}&companySeq={1}&earlierPassword={2}&newPassword={3}"
    static let GET_NOTES = ACTION_API_URL + "NoteAction.php?call=getAllNotes&userSeq={0}&companySeq={1}"
    static let GET_NOTE_DETAIL = ACTION_API_URL + "NoteAction.php?call=getNoteDetails&userSeq={0}&companySeq={1}&noteSeq={2}"
    static let GET_ACHIEVEMENTS = ACTION_API_URL + "UserAction.php?call=myAchievements&userSeq={0}&companyseq={1}"
    static let SAVE_NOTES = ACTION_API_URL + "NoteAction.php?call=saveNote&userSeq={0}&companySeq={1}&seq={2}&details={3}"
    
    //Learning Plan Actions
    static let GET_LEARNING_PLAN = ACTION_API_URL + "LearningPlanAction.php?call=getLearningPlans&userSeq={0}&companySeq={1}"
    static let GET_LEARNING_PLAN_DETAIL = ACTION_API_URL + "LearningPlanAction.php?userSeq={0}&companySeq={1}&call=getLearningPlanDetails"
    
    //Badge Actions
    static let GET_ACHIEVEMENT_BADGES = ACTION_API_URL + "BadgeAction.php?call=myAchievementMyBadges&userSeq={0}&companyseq={1}"
    
    //Message Actions
    static let GET_MESSSAGES = ACTION_API_URL + "MessageAction.php?call=getMessages&userSeq={0}&companySeq={1}"
    
    //Module Actions
    static let GET_MODULES = ACTION_API_URL + "ModuleAction.php?&call=getDirectModules&userSeq={0}&companySeq={1}"
    static let GET_MODULE_DETAIL = ACTION_API_URL + "ModuleAction.php?call=getModuleDetails&userSeq={0}&moduleSeq={1}&learningPlanSeq={2}"
    
    static let SUBMIT_MODULE_PROGRESS = ACTION_API_URL  + "QuizProgressAction.php?call=saveQuizProgress&userSeq={0}&companySeq={1}&answers={2}"
    
    //ActivityAction
    static let SAVE_ACTIVITY = ACTION_API_URL + "ActivityAction.php?call=saveActivity&userSeq={0}&companySeq={1}&activityData={2}"
    
    //Action Names
    static let DASHBOARD_DATA_ACTION = "getDashboardData"
    static let NOTIFICATION_ACTION = "getNotifications"
    static let LEARNING_PLAN_ACTION = "getLearningPlans"
}
