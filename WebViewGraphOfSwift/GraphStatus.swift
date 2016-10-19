//
//  GraphStatus.swift
//  WebViewGraphOfSwift
//
//  Created by 酒井文也 on 2015/12/17.
//  Copyright © 2015年 just1factory. All rights reserved.
//

//グラフのパターンを定義したenum
enum GraphStatus {
    
    case barGraph
    case lineGraph
    
    //初期値を返す
    func initalValue() -> Int {
        return 0
    }
    
    //状態に対応する値を返す
    func returnValue() -> Int {
        switch (self) {
        case .barGraph:
            return 0
        case .lineGraph:
            return 1
        }
    }
    
}
