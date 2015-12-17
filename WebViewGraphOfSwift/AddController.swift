//
//  AddController.swift
//  WebViewGraphOfSwift
//
//  Created by 酒井文也 on 2015/12/17.
//  Copyright © 2015年 just1factory. All rights reserved.
//

import UIKit

class AddController: UIViewController,UITextFieldDelegate {

    //メンバ変数
    var foodName: String = ""
    var calorieAmount: String = ""
    var eatDate: String = ""
    
    //画面に配置された部品
    @IBOutlet var foodNameField: UITextField!
    @IBOutlet var calorieAmountField: UITextField!
    @IBOutlet var eatDateField: UITextField!
    @IBOutlet var foodPicture: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UITextFieldのプレースホルダーを設定
        self.foodNameField.placeholder = "例）てんぷらそば"
        self.calorieAmountField.placeholder = "例）730"
        self.eatDateField.placeholder = "例）20151222"
        
        //UITextFieldのその他設定
        self.calorieAmountField.keyboardType = UIKeyboardType.NumberPad
        
    }

    //背景をタップしてキーボードを引っ込めるアクション
    @IBAction func hideKeyboardAction(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    //カメラ・フォトライブラリを起動するアクション
    @IBAction func activateCameraAction(sender: UIButton) {
        
        //@todo:UIActionSheetを起動して選択させて、カメラ・フォトライブラリを起動
    }
    
    //前の画面に戻るアクション
    @IBAction func backViewControllerAction(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //カロリーデータを記録するアクション
    @IBAction func saveCalorieDataAction(sender: UIButton) {
        
        //@todo:バリデーションを通して、OK:データを1件Realmにセーブする / Error:UIAlertControllerでエラーメッセージ表示、
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
