//
//  ChangeDateOrString.swift
//  WebViewGraphOfSwift
//
//  Created by 酒井文也 on 2015/12/18.
//  Copyright © 2015年 just1factory. All rights reserved.
//

import UIKit

//日付をDateまたはStringの相互変換用のstruct
struct ChangeDateOrString {
    
    //NSDate → Stringへの変換
    static func convertDateToString (_ date: Date) -> String {
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let dateString: String = dateFormatter.string(from: date)
        return dateString
    }

    //String → NSDateへの変換
    static func convertStringToDate (_ dateString: String!) -> Date {
        
        if dateString != nil {
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ja")
            dateFormatter.dateFormat = "yyyy/MM/dd"
            let stringDate: Date = dateFormatter.date(from: dateString)!
            return stringDate
        } else {
            let date = Date()
            return date
        }
    }
    
}
