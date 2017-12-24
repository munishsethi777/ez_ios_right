//
//  PreferencesUtil.swift
//  RightManagement
//
//  Created by Baljeet Gaheer on 15/11/17.
//  Copyright © 2017 Munish Sethi. All rights reserved.
//

import Foundation
class PreferencesUtil{
    static let sharedInstance = PreferencesUtil()
    static let LOGGED_IN_USER_SEQ_KEY = "loggedInUserSeq"
    static let LOGGED_IN_COMPANY_SEQ_KEY = "loggedInCompanySeq"
    func setLoggedInUserSeq(userSeq:Int){
        setValue(key: PreferencesUtil.LOGGED_IN_USER_SEQ_KEY,value: userSeq)
    }
    
    func getLoggedInUserSeq()-> Int{
       return getValueInt(key: PreferencesUtil.LOGGED_IN_USER_SEQ_KEY)
    }
    
    func setLoggedInCompanySeq(companySeq:Int){
        setValue(key: PreferencesUtil.LOGGED_IN_COMPANY_SEQ_KEY,value: companySeq)
    }
    
    func getLoggedInCompanySeq()-> Int{
        return getValueInt(key: PreferencesUtil.LOGGED_IN_COMPANY_SEQ_KEY)
    }
    
    func getValueInt(key: String)->Int{
        let userDefaults = UserDefaults.standard
        return userDefaults.integer(forKey:key)
    }
    
    func setValue(key: String,value:Any){
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(value, forKey: key)
    }
    
    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            if(key == PreferencesUtil.LOGGED_IN_USER_SEQ_KEY || key == PreferencesUtil.LOGGED_IN_COMPANY_SEQ_KEY){
                defaults.removeObject(forKey: key)
            }
        }
    }
}
