//
//  UserMgr.swift
//  RightManagement
//
//  Created by Baljeet Gaheer on 15/11/17.
//  Copyright © 2017 Munish Sethi. All rights reserved.
//

import Foundation
import CoreData
class UserMgr{
    static let sharedInstance = UserMgr()
    let coreDataManager = CoreDataManager(modelName: "right")
    func saveUser(response: [String: Any]){
        let userJson = response["user"] as! [String:Any]
        var user = NSEntityDescription.insertNewObject(forEntityName: "Users", into: coreDataManager.managedObjectContext) as! Users
        let userName = userJson["username"] as? String
        let userSeq = Int(userJson["id"] as! String)! ;
        let existingUser = getUserByUserSeq(userSeq: userSeq) as Users?
        if(existingUser != nil){
            user = existingUser!;
        }
        user.username = userName
        user.userseq = Int16(userJson["id"] as! String)!
        user.companyseq = Int16(userJson["companyseq"] as! String)!
        user.emailid = userJson["email"] as? String
        user.imagename = userJson["userImage"] as? String
        user.profiles = userJson["profiles"] as? String
        user.ismanager = false
        do {
            try coreDataManager.managedObjectContext.save()
            PreferencesUtil.sharedInstance.setLoggedInUserSeq(userSeq: Int(user.userseq))
            PreferencesUtil.sharedInstance.setLoggedInCompanySeq(companySeq: Int(user.companyseq))
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    func getUserByUserSeq(userSeq: Int)->Users?{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        let id = String(userSeq)
        fetchRequest.predicate = NSPredicate(format: "userseq == %d", userSeq)
        do {
            let fetchedUsers = try coreDataManager.managedObjectContext.fetch(fetchRequest) as? [Users]
            return fetchedUsers?.first
        } catch {
            fatalError("Failure to get context: \(error)")
        }
    }
}
