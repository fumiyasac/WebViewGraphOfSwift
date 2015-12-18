//
//  TextFieldIdentifier.swift
//  WebViewGraphOfSwift
//
//  Created by 酒井文也 on 2015/12/17.
//  Copyright © 2015年 just1factory. All rights reserved.
//

//テキストフィールドのパターンを定義したenum
enum TextFieldIdentifier {
    
    //テキストフィールドの名称
    case InputFood
    case InputCalorie
    case InputDate
    
    //状態に対応する値を返す
    func returnValue() -> Int {
        
        //各々のケース
        switch (self) {
            case .InputFood:
                return 0
            case .InputCalorie:
                return 1
            case .InputDate:
                return 2
        }
    }
    
}