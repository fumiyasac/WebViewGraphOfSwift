//
//  ChangeNSDateOrString.swift
//  WebViewGraphOfSwift
//
//  Created by 酒井文也 on 2015/12/18.
//  Copyright © 2015年 just1factory. All rights reserved.
//

import UIKit

struct ChangeNSDateOrString {
    
    //NSDate → Stringへの変換
    static func convertNSDateToString (date: NSDate) -> String {
        
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP")
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let dateString: String = dateFormatter.stringFromDate(date)
        return dateString
    }

    //String → NSDateへの変換
    static func convertStringToNSDate (dateString: String!) -> NSDate {
        
        if dateString != nil {
            let dateFormatter: NSDateFormatter = NSDateFormatter()
            dateFormatter.locale = NSLocale(localeIdentifier: "ja")
            dateFormatter.dateFormat = "yyyy/MM/dd"
            let stringDate: NSDate = dateFormatter.dateFromString(dateString)!
            return stringDate
        } else {
            let date = NSDate()
            return date
        }
    }
    
}
