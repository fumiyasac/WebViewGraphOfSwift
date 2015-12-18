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

class AddController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //メンバ変数
    var foodName: String!
    var calorieAmount: String!
    var eatDate: String!
    
    var selectedImage: UIImage!
    
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
        
        //画像の描画モードの指定
        self.foodPicture.contentMode = UIViewContentMode.ScaleToFill
        self.selectedImage = UIImage(named: "noimage.png")
        self.foodPicture.image = self.selectedImage
        
        //UITextFieldのプレースホルダーを設定
        self.foodNameField.placeholder = "(例）てんぷらそば"
        self.calorieAmountField.placeholder = "(例）730"
        self.eatDateField.placeholder = "(例）2015/12/22"
        
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
    }
    
    //デイトピッカーを非表示にする
    func hideDatePicker() {
        self.datepickerBackground.alpha = 0
        self.datepickerButton.alpha = 0
        self.datepickerButton.enabled = false
        self.datepickerArea.alpha = 0
        self.datepickerArea.enabled = false
    }
    
    //※ボタンアクションだとキーボードが重なってしまうのでUITextFieldDelegateを使う
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {

        //カメラボタンを無効にする
        self.foodPictureBtn.enabled = false
        
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
        let dateString: String = ChangeNSDateOrString.convertNSDateToString(self.datepickerArea.date)
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
        
        //UIActionSheetを起動して選択させて、カメラ・フォトライブラリを起動
        let alertActionSheet = UIAlertController(
            title: "「食べたもの」の写真を記録する",
            message: "写真と一緒にカロリーを記録しましょう(^^)",
            preferredStyle: UIAlertControllerStyle.ActionSheet
        )
        
        //UIActionSheetの戻り値をチェック
        alertActionSheet.addAction(
            UIAlertAction(
                title: "ライブラリから選択",
                style: UIAlertActionStyle.Default,
                handler: handlerActionSheet
            )
        )
        alertActionSheet.addAction(
            UIAlertAction(
                title: "カメラで撮影",
                style: UIAlertActionStyle.Default,
                handler: handlerActionSheet
            )
        )
        alertActionSheet.addAction(
            UIAlertAction(
                title: "キャンセル",
                style: UIAlertActionStyle.Cancel,
                handler: handlerActionSheet
            )
        )
        presentViewController(alertActionSheet, animated: true, completion: nil)
    }
    
    //アクションシートの結果に応じて処理を変更
    func handlerActionSheet(ac: UIAlertAction) -> Void {
        
        switch ac.title! {

            case "ライブラリから選択":
                self.selectAndDisplayFromPhotoLibrary()
                break
            case "カメラで撮影":
                self.loadAndDisplayFromCamera()
                break
            case "キャンセル":
                break
            default:
                break
        }
        
    }
    
    //ライブラリから写真を選択してimageに書き出す
    func selectAndDisplayFromPhotoLibrary() {
        
        //フォトアルバムを表示
        let ipc = UIImagePickerController()
        ipc.delegate = self
        ipc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(ipc, animated: true, completion: nil)
    }

    //カメラで撮影してimageに書き出す
    func loadAndDisplayFromCamera() {
        
        //カメラを起動
        let ip = UIImagePickerController()
        ip.delegate = self
        ip.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(ip, animated: true, completion: nil)
    }
    
    //画像を選択した時のイベント
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        //画像をセットして戻る
        self.dismissViewControllerAnimated(true, completion: nil)
        
        //リサイズして表示する
        let resizedImage = CGRectMake(
            image.size.width / 4.0,
            image.size.height / 4.0,
            image.size.width / 2.0,
            image.size.height / 2.0
        )
        let cgImage = CGImageCreateWithImageInRect(image.CGImage, resizedImage)
        self.foodPicture.image = UIImage(CGImage: cgImage!)
        //self.foodPicture.image = image
    }
    
    //前の画面に戻るアクション
    @IBAction func backViewControllerAction(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //カロリーデータを記録するアクション
    @IBAction func saveCalorieDataAction(sender: UIButton) {
        
        //UIImageデータを取得する
        self.selectedImage = self.foodPicture.image
        
        //バリデーションを通す前の準備
        self.foodName = self.foodNameField.text
        self.calorieAmount = self.calorieAmountField.text
        self.eatDate = self.eatDateField.text
        
        //Error:UIAlertControllerでエラーメッセージ表示
        if (self.foodName.isEmpty || self.calorieAmount.isEmpty || self.eatDate.isEmpty) {
            
            //エラーのアラートを表示してOKを押すと戻る
            let errorAlert = UIAlertController(
                title: "エラー",
                message: "入力必須の項目に不備があります。",
                preferredStyle: UIAlertControllerStyle.Alert
            )
            errorAlert.addAction(
                UIAlertAction(
                    title: "OK",
                    style: UIAlertActionStyle.Default,
                    handler: nil
                )
            )
            presentViewController(errorAlert, animated: true, completion: nil)
        
        //OK:データを1件Realmにセーブする
        } else {
            
            //Realmにデータを1件登録する
            let calorieObject = Calorie.create()
            calorieObject.food = self.foodName
            calorieObject.image = self.selectedImage
            calorieObject.amount = Int(self.calorieAmount)!
            
            //String（yyyy/MM/dd）をNSDate型に変換
            let calorieDate: NSDate = ChangeNSDateOrString.convertStringToNSDate(self.eatDate)
            calorieObject.eatDate = calorieDate
            
            //Debug.
            //print(self.foodName)
            //print(self.selectedImage)
            //print(Int(self.calorieAmount)!)
            //print(calorieDate)
            
            //登録処理
            calorieObject.save()
            
            //全ボタン非活性
            self.foodNameField.enabled = false
            self.calorieAmountField.enabled = false
            self.eatDateField.enabled = false
            self.foodPictureBtn.enabled = false
            
            //登録されたアラートを表示してOKを押すと戻る
            let errorAlert = UIAlertController(
                title: "完了",
                message: "入力データが登録されました。",
                preferredStyle: UIAlertControllerStyle.Alert
            )
            errorAlert.addAction(
                UIAlertAction(
                    title: "OK",
                    style: UIAlertActionStyle.Default,
                    handler: saveComplete
                )
            )
            presentViewController(errorAlert, animated: true, completion: nil)
        }
        
    }
    
    //登録が完了した際のアクション
    func saveComplete(ac: UIAlertAction) -> Void {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
