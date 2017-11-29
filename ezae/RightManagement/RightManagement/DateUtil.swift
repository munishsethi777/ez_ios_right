//
//  DateUtil.swift
//  RightManagement
//
//  Created by Baljeet Gaheer on 29/11/17.
//  Copyright © 2017 Munish Sethi. All rights reserved.
//

import Foundation

class DateUtil{
    static let sharedInstance = DateUtil()
    static let format = "MMM d, yyyy HH:mm a"
    func stringToDate(dateStr: String)-> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: dateStr)
        return date!;
    }
    
    func dateToString(date: Date,format: String)-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let myStringafd = dateFormatter.string(from: date)
        return myStringafd;
    }
}
