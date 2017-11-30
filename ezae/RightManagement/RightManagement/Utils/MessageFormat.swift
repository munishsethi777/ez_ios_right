//
//  MessageFormat.swift
//  right
//
//  Created by Baljeet Gaheer on 14/11/17.
//  Copyright © 2017 Baljeet Gaheer. All rights reserved.
//

import Foundation

class MessageFormat{
    static func format(pattern: String,args: [String])->String{
        var url: String = pattern
        var count: Int = 0
        for arg in args{
            url = url.replacingOccurrences(of: "{"+String(count)+"}", with: arg)
            count+=1
        }
        return url
    }
    static func format(pattern: String,args: [Int])->String{
        var url: String = pattern
        var count: Int = 0
        for arg in args{
            url = url.replacingOccurrences(of: "{"+String(count)+"}", with: String(arg))
            count+=1
        }
        return url
    }
}
