//
//  Calorie.swift
//  WebViewGraphOfSwift
//
//  Created by 酒井文也 on 2015/12/17.
//  Copyright © 2015年 just1factory. All rights reserved.
//

import UIKit


//Realmクラスのインポート
import RealmSwift

class Calorie: Object {
    
    //Realmクラスのインスタンス
    static let realm = try! Realm()
    
    //id
    dynamic private var id = 0
    
    //今食べたもの
    dynamic var food = ""
    
    //推定カロリー
    dynamic var amount = 0
    
    //食べた日にち
    dynamic var eatDate = NSDate(timeIntervalSince1970: 0)
    
    //その時の写真
    /**
     * 下記記事で紹介されている実装を元に作成
     *
     * JFYI：(Qiita) Realm × Swift2 でシームレスに画像を保存する
     * http://qiita.com/_ha1f/items/593ca4f9c97ae697fc75
     *
     */
    //
    dynamic private var _image: UIImage? = nil
    
    dynamic var image: UIImage? {
        
        //setter
        set{
            self._image = newValue
            if let value = newValue {
                self.imageData = UIImagePNGRepresentation(value)
            }
        }
        
        //getter
        get{
            if let image = self._image {
                return image
            }
            if let data = self.imageData {
                self._image = UIImage(data: data)
                return self._image
            }
            return nil
        }
    }
    
    dynamic private var imageData: NSData? = nil
    
    //PrimaryKeyの設定
    override static func primaryKey() -> String? {
        return "id"
    }
    
    //保存しないプロパティの一覧
    override static func ignoredProperties() -> [String] {
        return ["image", "_image"]
    }
    
    //新規追加用のインスタンス生成メソッド
    static func create() -> Calorie {
        let calorie = Calorie()
        calorie.id = self.getLastId()
        return calorie
    }
    
    //プライマリキーの作成メソッド
    static func getLastId() -> Int {
        if let calorie = realm.objects(Calorie).last {
            return calorie.id + 1
        } else {
            return 1
        }
    }
    
    //インスタンス保存用メソッド
    func save() {
        try! Calorie.realm.write {
            Calorie.realm.add(self)
        }
    }
    
    //インスタンス削除用メソッド
    func delete() {
        try! Calorie.realm.write {
            Calorie.realm.delete(self)
        }
    }
    
    //登録日順のデータの全件取得をする
    static func fetchAllCalorieListSortByDate() -> [Calorie] {
        let calories = realm.objects(Calorie).sorted("eatDate", ascending: false)
        var calorieList: [Calorie] = []
        for calorie in calories {
            calorieList.append(calorie)
        }
        return calorieList
    }
    
    //カロリー順のデータの全件取得をする
    static func fetchAllCalorieListSortByAmount() -> [Calorie] {
        
        let calories = realm.objects(Calorie).sorted("amount", ascending: false)
        var calorieList: [Calorie] = []
        for calorie in calories {
            calorieList.append(calorie)
        }
        return calorieList
    }
}
