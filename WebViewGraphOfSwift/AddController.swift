//
//  AddController.swift
//  WebViewGraphOfSwift
//
//  Created by 酒井文也 on 2015/12/17.
//  Copyright © 2015年 just1factory. All rights reserved.
//

import UIKit

//Realmクラスのインポート
import RealmSwift

class AddController: UIViewController,UITextFieldDelegate {

    //メンバ変数
    var foodName: String = ""
    var calorieAmount: Int = 0
    var eatDate: String = ""
    
    //画面に配置された部品（入力用の要素）
    @IBOutlet var foodNameField: UITextField!
    @IBOutlet var calorieAmountField: UITextField!
    @IBOutlet var eatDateField: UITextField!
    @IBOutlet var foodPicture: UIImageView!
    @IBOutlet var foodPictureBtn: UIButton!
    
    //画面に配置された部品（デイトピッカーまわり）
    @IBOutlet var datepickerBackground: UIView!
    @IBOutlet var datepickerButton: UIButton!
    @IBOutlet var datepickerArea: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UITextFieldのプレースホルダーを設定
        self.foodNameField.placeholder = "例）てんぷらそば"
        self.calorieAmountField.placeholder = "例）730"
        self.eatDateField.placeholder = "例）2015/12/22"
        
        //UITextFieldを識別するためのタグ
        self.foodNameField.tag = TextFieldIdentifier.InputFood.returnValue()
        self.calorieAmountField.tag = TextFieldIdentifier.InputCalorie.returnValue()
        self.eatDateField.tag = TextFieldIdentifier.InputDate.returnValue()
        
        //UITextFieldのその他設定
        self.calorieAmountField.keyboardType = UIKeyboardType.NumberPad
        self.foodNameField.delegate = self
        self.calorieAmountField.delegate = self
        self.eatDateField.delegate = self
        self.hideDatePicker()
    }

    //デイトピッカーを表示する
    func showDatePicker() {
        self.datepickerBackground.alpha = 1
        self.datepickerButton.alpha = 1
        self.datepickerButton.enabled = true
        self.datepickerArea.alpha = 1
        self.datepickerArea.enabled = true
        self.foodPictureBtn.enabled = false
    }
    
    //デイトピッカーを非表示にする
    func hideDatePicker() {
        self.datepickerBackground.alpha = 0
        self.datepickerButton.alpha = 0
        self.datepickerButton.enabled = false
        self.datepickerArea.alpha = 0
        self.datepickerArea.enabled = false
        self.foodPictureBtn.enabled = true
    }
    
    //※ボタンアクションだとキーボードが重なってしまうのでUITextFieldDelegateを使う
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        //「食べた日にち」のテキストフィールドタップ時のアクションのテキストフィールドがタップされた際はデイトピッカーを表示する
        if textField.tag == TextFieldIdentifier.InputDate.returnValue() {

            self.foodNameField.enabled = false
            self.calorieAmountField.enabled = false
            self.eatDateField.enabled = true
            self.showDatePicker()
            return false
            
        } else {
            
            //「今食べたもの」のテキストフィールドタップ時のアクション
            if textField.tag == TextFieldIdentifier.InputCalorie.returnValue() {
                
                self.foodNameField.enabled = false
                self.calorieAmountField.enabled = true
                self.eatDateField.enabled = false
                self.hideDatePicker()
            
            //「推定カロリー」のテキストフィールドタップ時のアクション
            } else if textField.tag == TextFieldIdentifier.InputFood.returnValue() {
                
                self.foodNameField.enabled = true
                self.calorieAmountField.enabled = false
                self.eatDateField.enabled = false
                self.hideDatePicker()
            }
            return true
        }

    }
    
    //背景をタップしてキーボードを引っ込めるアクション
    @IBAction func hideKeyboardAction(sender: UITapGestureRecognizer) {
        
        //表示キーワード・デイトピッカーを隠す
        self.view.endEditing(true)
        self.hideDatePicker()
        
        //ハイライトやボタン状態を元に戻す
        self.resetTextFieldStatus()
    }
    
    //デイトピッカーのボタンを押した際のアクション
    @IBAction func inputDatepickerAction(sender: UIButton) {
        
        //デイトピッカーを隠す
        self.hideDatePicker()
        
        //YYYY/MM/DDの状態に整形してテキストフィールドへ表示
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP")
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let dateString: String = dateFormatter.stringFromDate(self.datepickerArea.date)
        self.eatDateField.text = dateString
        
        //ハイライトやボタン状態を元に戻す
        self.resetTextFieldStatus()
    }
    
    //テキストフィールド等を元の状態に戻す
    func resetTextFieldStatus() {

        //非活性状態の解除
        self.foodNameField.enabled = true
        self.calorieAmountField.enabled = true
        self.eatDateField.enabled = true
        self.foodPictureBtn.enabled = true
        
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
