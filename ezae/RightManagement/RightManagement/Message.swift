//
//  Message.swift
//  RightManagement
//
//  Created by Munish Sethi on 10/10/17.
//  Copyright © 2017 Munish Sethi. All rights reserved.
//

import UIKit

class Message{
    
    var messageTitle: String
    var messageDescription : String
    var dated : String
    var userSeq :Integer
    var isSent:Bool
    
    init(messageTitle:String,messageDescription:String){
        self.messageTitle = messageTitle
        self.messageDescription = messageDescription
    }
}
