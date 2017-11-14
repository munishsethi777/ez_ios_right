//
//  Notification.swift
//  RightManagement
//
//  Created by Munish Sethi on 11/10/17.
//  Copyright © 2017 Munish Sethi. All rights reserved.
//

import Foundation
class Notification{
    var seq:Int
    var title:String
    var notificationType:String
    
    init(seq:Int,title:String,notificationType:String){
        self.seq = seq
        self.title = title
        self.notificationType = notificationType
    }
    
}
