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
    case inputFood
    case inputCalorie
    case inputDate
    
    //状態に対応する値を返す
    func returnValue() -> Int {
        
        //各々のケース
        switch (self) {
            case .inputFood:
                return 0
            case .inputCalorie:
                return 1
            case .inputDate:
                return 2
        }
    }
    
}
