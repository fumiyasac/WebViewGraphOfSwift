//
//  Calorie.swift
//  WebViewGraphOfSwift
//
//  Created by 酒井文也 on 2015/12/17.
//  Copyright © 2015年 just1factory. All rights reserved.
//

import Foundation

//RealmSwiftクラスのインポート
import RealmSwift

class ToDo: Object{

    
    
    
    /// 名前
    dynamic var name = ""
    /// 期限
    dynamic var deadLine = NSDate(timeIntervalSince1970: 0)
    /// 完了フラグ
    dynamic var isComplete = false
}