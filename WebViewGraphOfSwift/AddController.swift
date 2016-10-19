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
        self.foodPicture.contentMode = UIViewContentMode.scaleToFill
        self.selectedImage = UIImage(named: "noimage.png")
        self.foodPicture.image = self.selectedImage
        
        //UITextFieldのプレースホルダーを設定
        self.foodNameField.placeholder = "(例）てんぷらそば"
        self.calorieAmountField.placeholder = "(例）730"
        self.eatDateField.placeholder = "(例）2015/12/22"
        
        //UITextFieldを識別するためのタグ
        self.foodNameField.tag = TextFieldIdentifier.inputFood.returnValue()
        self.calorieAmountField.tag = TextFieldIdentifier.inputCalorie.returnValue()
        self.eatDateField.tag = TextFieldIdentifier.inputDate.returnValue()
        
        //UITextFieldのその他設定
        self.calorieAmountField.keyboardType = UIKeyboardType.numberPad
        self.foodNameField.delegate = self
        self.calorieAmountField.delegate = self
        self.eatDateField.delegate = self
        self.hideDatePicker()
    }

    //デイトピッカーを表示する
    func showDatePicker() {
        self.datepickerBackground.alpha = 1
        self.datepickerButton.alpha = 1
        self.datepickerButton.isEnabled = true
        self.datepickerArea.alpha = 1
        self.datepickerArea.isEnabled = true
    }
    
    //デイトピッカーを非表示にする
    func hideDatePicker() {
        self.datepickerBackground.alpha = 0
        self.datepickerButton.alpha = 0
        self.datepickerButton.isEnabled = false
        self.datepickerArea.alpha = 0
        self.datepickerArea.isEnabled = false
    }
    
    //※ボタンアクションだとキーボードが重なってしまうのでUITextFieldDelegateを使う
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {

        //カメラボタンを無効にする
        self.foodPictureBtn.isEnabled = false
        
        //「食べた日にち」のテキストフィールドタップ時のアクションのテキストフィールドがタップされた際はデイトピッカーを表示する
        if textField.tag == TextFieldIdentifier.inputDate.returnValue() {

            self.foodNameField.isEnabled = false
            self.calorieAmountField.isEnabled = false
            self.eatDateField.isEnabled = true
            self.showDatePicker()
            return false
            
        } else {
            
            //「今食べたもの」のテキストフィールドタップ時のアクション
            if textField.tag == TextFieldIdentifier.inputCalorie.returnValue() {
                
                self.foodNameField.isEnabled = false
                self.calorieAmountField.isEnabled = true
                self.eatDateField.isEnabled = false
                self.hideDatePicker()
            
            //「推定カロリー」のテキストフィールドタップ時のアクション
            } else if textField.tag == TextFieldIdentifier.inputFood.returnValue() {
                
                self.foodNameField.isEnabled = true
                self.calorieAmountField.isEnabled = false
                self.eatDateField.isEnabled = false
                self.hideDatePicker()
            }
            return true
        }

    }
    
    //背景をタップしてキーボードを引っ込めるアクション
    @IBAction func hideKeyboardAction(_ sender: UITapGestureRecognizer) {
        
        //表示キーワード・デイトピッカーを隠す
        self.view.endEditing(true)
        self.hideDatePicker()
        
        //ハイライトやボタン状態を元に戻す
        self.resetTextFieldStatus()
    }
    
    //デイトピッカーのボタンを押した際のアクション
    @IBAction func inputDatepickerAction(_ sender: UIButton) {
        
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
        self.foodNameField.isEnabled = true
        self.calorieAmountField.isEnabled = true
        self.eatDateField.isEnabled = true
        self.foodPictureBtn.isEnabled = true
        
    }
    
    //カメラ・フォトライブラリを起動するアクション
    @IBAction func activateCameraAction(_ sender: UIButton) {
        
        //UIActionSheetを起動して選択させて、カメラ・フォトライブラリを起動
        let alertActionSheet = UIAlertController(
            title: "「食べたもの」の写真を記録する",
            message: "写真と一緒にカロリーを記録しましょう(^^)",
            preferredStyle: UIAlertControllerStyle.actionSheet
        )
        
        //UIActionSheetの戻り値をチェック
        alertActionSheet.addAction(
            UIAlertAction(
                title: "ライブラリから選択",
                style: UIAlertActionStyle.default,
                handler: handlerActionSheet
            )
        )
        alertActionSheet.addAction(
            UIAlertAction(
                title: "カメラで撮影",
                style: UIAlertActionStyle.default,
                handler: handlerActionSheet
            )
        )
        alertActionSheet.addAction(
            UIAlertAction(
                title: "キャンセル",
                style: UIAlertActionStyle.cancel,
                handler: handlerActionSheet
            )
        )
        present(alertActionSheet, animated: true, completion: nil)
    }
    
    //アクションシートの結果に応じて処理を変更
    func handlerActionSheet(_ ac: UIAlertAction) -> Void {
        
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
        ipc.allowsEditing = true
        ipc.delegate = self
        ipc.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(ipc, animated: true, completion: nil)
    }

    //カメラで撮影してimageに書き出す
    func loadAndDisplayFromCamera() {
        
        //カメラを起動
        let ip = UIImagePickerController()
        ip.allowsEditing = true
        ip.delegate = self
        ip.sourceType = UIImagePickerControllerSourceType.camera
        present(ip, animated: true, completion: nil)
    }
    
    //画像を選択した時のイベント
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        //画像をセットして戻る
        self.dismiss(animated: true, completion: nil)
        
        //リサイズして表示する
        let resizedImage = CGRect(
            x: image.size.width / 4.0,
            y: image.size.height / 4.0,
            width: image.size.width / 2.0,
            height: image.size.height / 2.0
        )
        let cgImage = (image.cgImage)?.cropping(to: resizedImage)
        self.foodPicture.image = UIImage(cgImage: cgImage!)
        //self.foodPicture.image = image
    }
    
    //前の画面に戻るアクション
    @IBAction func backViewControllerAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //カロリーデータを記録するアクション
    @IBAction func saveCalorieDataAction(_ sender: UIButton) {
        
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
                preferredStyle: UIAlertControllerStyle.alert
            )
            errorAlert.addAction(
                UIAlertAction(
                    title: "OK",
                    style: UIAlertActionStyle.default,
                    handler: nil
                )
            )
            present(errorAlert, animated: true, completion: nil)
        
        //OK:データを1件Realmにセーブする
        } else {
            
            //Realmにデータを1件登録する
            let calorieObject = Calorie.create()
            calorieObject.food = self.foodName
            calorieObject.image = self.selectedImage
            calorieObject.amount = Int(self.calorieAmount)!
            
            //String（yyyy/MM/dd）をNSDate型に変換
            let calorieDate: Date = ChangeNSDateOrString.convertStringToNSDate(self.eatDate)
            calorieObject.eatDate = calorieDate
            
            //登録処理
            calorieObject.save()
            
            //全ボタン非活性
            self.foodNameField.isEnabled = false
            self.calorieAmountField.isEnabled = false
            self.eatDateField.isEnabled = false
            self.foodPictureBtn.isEnabled = false
            
            //登録されたアラートを表示してOKを押すと戻る
            let errorAlert = UIAlertController(
                title: "完了",
                message: "入力データが登録されました。",
                preferredStyle: UIAlertControllerStyle.alert
            )
            errorAlert.addAction(
                UIAlertAction(
                    title: "OK",
                    style: UIAlertActionStyle.default,
                    handler: saveComplete
                )
            )
            present(errorAlert, animated: true, completion: nil)
        }
        
    }
    
    //登録が完了した際のアクション
    func saveComplete(_ ac: UIAlertAction) -> Void {
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
