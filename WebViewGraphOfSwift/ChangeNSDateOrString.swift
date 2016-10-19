//
//  ChangeNSDateOrString.swift
//  WebViewGraphOfSwift
//
//  Created by 酒井文也 on 2015/12/18.
//  Copyright © 2015年 just1factory. All rights reserved.
//

import UIKit

//日付をNSDateまたはStringの相互変換用のstruct
struct ChangeNSDateOrString {
    
    //NSDate → Stringへの変換
    static func convertNSDateToString (_ date: Date) -> String {
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let dateString: String = dateFormatter.string(from: date)
        return dateString
    }

    //String → NSDateへの変換
    static func convertStringToNSDate (_ dateString: String!) -> Date {
        
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
