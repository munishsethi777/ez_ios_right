//
//  ChatModel.swift
//  RightManagement
//
//  Created by Baljeet Gaheer on 04/01/18.
//  Copyright © 2018 Munish Sethi. All rights reserved.
//

import UIKit
class ChatModel{
    var seq:Int
    var title:String
    var imageUrl:String
    init(seq:Int,title:String,imageUrl:String){
        self.seq = seq
        self.title = title
        self.imageUrl = imageUrl
    }
}
