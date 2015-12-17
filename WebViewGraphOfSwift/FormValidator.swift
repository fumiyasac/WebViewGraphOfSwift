//
//  FormValidator.swift
//  WebViewGraphOfSwift
//
//  Created by 酒井文也 on 2015/12/17.
//  Copyright © 2015年 just1factory. All rights reserved.
//

/**
 * UITextFieldのバリデーター関数
 */

import UIKit

struct FormValidator {
    
    //受け取る文字列が空かを判定
    static func checkExistString(targetString: String) -> Bool {
        
        if targetString.isEmpty {
            return false
        } else {
            return true
        }
    }
    
    //受け取る値が数値かを判定
    static func checkNumeric(targetValue: AnyObject) -> Bool {
        
        let targetIntValue: Int? = Int(targetValue as! String)
        if targetIntValue == nil {
            return false
        } else {
            return true
        }
    }
    
    //受け取る値(YYYYMMDD ※8文字以内)の形式を超えていないかを判定
    /*
    static func checkDateLength(targetString: String, limitNumber: Int) -> Bool {
        
        if targetString.utf16.count > limitNumber {
            return false
        } else {
            return true
        }
    }
    */
    
}
