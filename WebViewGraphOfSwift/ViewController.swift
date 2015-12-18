//
//  ViewController.swift
//  WebViewGraphOfSwift
//
//  Created by 酒井文也 on 2015/12/15.
//  Copyright © 2015年 just1factory. All rights reserved.
//

import UIKit

//RealmSwiftのインポート
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate {

    //テーブルビューの要素数
    let sectionCount: Int = 1
    
    //テーブルビューセルの高さ(Xibのサイズに合わせるのが理想)
    let cellHeight: CGFloat = 60.0
    
    //テーブルビューのセル数
    var cellCount: Int!
    
    //テーブルデータ表示用に一時的にすべてのfetchデータを格納する
    var caloriesArray: NSMutableArray = []
    
    //グラフの状態
    var selectedGraph: GraphStatus!
        
    //画面に配置された部品
    @IBOutlet var grachWebView: UIWebView!
    @IBOutlet var selectGraphSegment: UISegmentedControl!
    @IBOutlet var recordTableView: UITableView!
    
    override func viewWillAppear(animated: Bool) {
        self.fetchAndReloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //WebViewのデリゲート設定（webViewDidFinishLoadを拾うため）
        /*
         * 右のinspectorより、
         * 1. Detectionの「PhoneNumbers」をはずす
         * 2. ViewのModeを「Aspect Fit」にする
         * 3. User Interaction Enabledのチェックをはずす
         * 4. Clears Graphics Contextのチェックをはずす
         */
        self.grachWebView.delegate = self
        
        //TableViewのデリゲート設定
        self.recordTableView.delegate = self
        self.recordTableView.dataSource = self
        
        //Xibのクラスを読み込む宣言を行う
        let nibDefault:UINib = UINib(nibName: "CalorieDataCell", bundle: nil)
        self.recordTableView.registerNib(nibDefault, forCellReuseIdentifier: "CalorieDataCell")
        
        //グラフの初期状態を設定する
        self.selectedGraph = GraphStatus.BarGraph
        
        //グラフを読み込む
        self.displayGraphBase(self.selectedGraph)
        
    }
    
    //各データのfetchとテーブルビューのリロードを行う
    func fetchAndReloadData() {
        
        //カロリーデータをフェッチする
        self.caloriesArray.removeAllObjects()
        let calories = Calorie.fetchAllCalorieList()
        
        //セル数の設定
        self.cellCount = calories.count
        
        //TableViewへの一覧表示用のデータを作成
        if self.cellCount != 0 {
            for calorie in calories {
                self.caloriesArray.addObject(calorie)
            }
        }
        
        //Debug.
        //print(self.caloriesArray)
        
        //テーブルビューをリロード
        self.reloadData()
    }
    
    //TableView: テーブルの要素数を設定する
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.sectionCount
    }
    
    //TableView: テーブルのセクションのセル数を設定する
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //@test: ダミーデータ
        return self.cellCount
    }
    
    //TableView: 表示するセルの中身を設定する
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //Xibファイルを元にデータを作成する
        let cell = tableView.dequeueReusableCellWithIdentifier("CalorieDataCell") as? CalorieDataCell
        
        //テキスト・画像等の表示
        let calorieData: Calorie = self.caloriesArray[indexPath.row] as! Calorie
        
        cell!.calorieTitle.text = calorieData.food
        cell!.calorieValue.text = String(calorieData.amount) + "kcal"
        
        //NSDate型は文字列に変換
        let eatDateString: String = ChangeNSDateOrString.convertNSDateToString(calorieData.eatDate)
        cell!.calorieDate.text = eatDateString
        
        //画像を表示させる
        cell!.calorieImage.image = calorieData.image

        //セルのアクセサリタイプと背景の設定
        cell!.accessoryType = UITableViewCellAccessoryType.None
        cell!.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell!
    }
    
    //TableView: セルをタップした時に呼び出される
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //@todo: go some controller...
    }
    
    //TableView: セルの高さを返す
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cellHeight
    }
    
    //TableView: テーブルビューをリロードする
    func reloadData(){
        self.recordTableView.reloadData()
    }

    //グラフの状態に応じてグラフデータを整形して読み込むアクション
    func displayGraphBase(status: GraphStatus) {
        
        switch (status) {
            
            //棒グラフ
            case GraphStatus.BarGraph:
                self.displayBarGraphToWebView()
                break
            
            //円グラフ
            case GraphStatus.PieGraph:
                self.displayPieGraphToWebView()
                break
            
            //折れ線グラフ
            case GraphStatus.LineGraph:
                self.displayLineGraphToWebView()
                break
        }
        
    }
    
    //@todo:棒グラフ用のデータを作成してWebViewへ描画
    func displayBarGraphToWebView() {
        
    }
    
    //@todo:円グラフ用のデータを作成してWebViewへ描画
    func displayPieGraphToWebView() {
        
    }
    
    //@todo:折れ線グラフ用のデータを作成してWebViewへ描画
    func displayLineGraphToWebView() {
        
    }
    
    //セグメントコントロールで切り替え時に行われるアクション
    @IBAction func changeGraphDisplayAction(sender: UISegmentedControl) {
        
        switch (sender.selectedSegmentIndex) {
        
            case GraphStatus.BarGraph.returnValue():
                self.selectedGraph = GraphStatus.BarGraph
                self.displayGraphBase(self.selectedGraph)
                break
            
            case GraphStatus.PieGraph.returnValue():
                self.selectedGraph = GraphStatus.PieGraph
                self.displayGraphBase(self.selectedGraph)
                break
            
            case GraphStatus.LineGraph.returnValue():
                self.selectedGraph = GraphStatus.LineGraph
                self.displayGraphBase(self.selectedGraph)
                break
            
            default:
                self.selectedGraph = GraphStatus.BarGraph
                self.displayGraphBase(self.selectedGraph)
                break
        }
    }
    
    //次のページに遷移するアクション
    @IBAction func goAddCalorieAction(sender: UIButton) {
        
        //詳細データを遷移先へ引き渡す処理（AddControllerのStoryBoardID：Add）
        let addController: AddController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Add") as! AddController
        self.presentViewController(addController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

