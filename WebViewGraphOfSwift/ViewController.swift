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
    
    //テーブルビューセルの高さ(高さ固定の場合Xibのサイズに合わせるのが理想)
    let cellHeight: CGFloat = 60.0
    
    //テーブルビューのセル数
    var cellCount: Int!
    
    //テーブルデータ表示用に一時的にすべてのfetchデータを格納する
    var caloriesArrayForCell: NSMutableArray = []
    
    //グラフ用の可変配列
    var caloriesArrayForBarChart: NSMutableArray = []
    
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
        
    }
    
    //各データのfetchとテーブルビューのリロードを行う
    func fetchAndReloadData() {
        
        //カロリーデータをフェッチしてTableViewへの一覧表示用のデータを作成
        //※折れ線グラフでも使う
        self.caloriesArrayForCell.removeAllObjects()
        let calories = Calorie.fetchAllCalorieListSortByDate()
        
        self.cellCount = calories.count
        
        if self.cellCount != 0 {
            for calorie in calories {
                self.caloriesArrayForCell.addObject(calorie)
            }
        }
        
        //棒グラフ用の可変配列の作成
        self.caloriesArrayForBarChart.removeAllObjects()
        let caloriesForBarChart = Calorie.fetchAllCalorieListSortByAmount()
        if caloriesForBarChart.count != 0 {
            for calorieForBarChart in caloriesForBarChart {
                self.caloriesArrayForBarChart.addObject(calorieForBarChart)
            }
        }
        
        //テーブルビューをリロード
        self.reloadData()
        
        //セグメントコントロール位置の初期設定
        self.selectGraphSegment.selectedSegmentIndex = 0
        
        //グラフの初期状態を設定する
        self.selectedGraph = GraphStatus.BarGraph
        
        //ローカルhtmlを読み込む
        self.loadLocalHtmlSource(self.selectedGraph)
    }
    
    //TableView: テーブルの要素数を設定する
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.sectionCount
    }
    
    //TableView: テーブルのセクションのセル数を設定する
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellCount
    }
    
    //TableView: Editableの状態にする.
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    //TableView: 特定の行のボタン操作を有効にする.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        print("commitEdittingStyle:\(editingStyle)")
    }
    
    //TableView: Buttonを拡張＆データ削除処理
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        //削除ボタン
        let myDeleteButton: UITableViewRowAction = UITableViewRowAction(style: .Normal, title: "削除") { (action, index) -> Void in
            
            //テーブルビューを編集不可にする
            tableView.editing = false
            
            //データを1件削除
            let calorieData: Calorie = self.caloriesArrayForCell[indexPath.row] as! Calorie
            calorieData.delete()
            
            //データをリロードする
            self.fetchAndReloadData()
            
        }
        myDeleteButton.backgroundColor = UIColor.redColor()
        return [myDeleteButton]
    }
    
    //TableView: 表示するセルの中身を設定する
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //Xibファイルを元にデータを作成する
        let cell = tableView.dequeueReusableCellWithIdentifier("CalorieDataCell") as? CalorieDataCell
        
        //テキスト・画像等の表示
        let calorieData: Calorie = self.caloriesArrayForCell[indexPath.row] as! Calorie
        
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
    
    //WebView: ローカルのHTMLファイルのロードが完了したら実行される
    func webViewDidFinishLoad(webView: UIWebView) {
        self.displayGraphBase(self.selectedGraph)
    }
    
    //ローカルのhtmlファイルを読み込む
    func loadLocalHtmlSource(status: GraphStatus) {
        
        //htmlファイルへアクセスする
        do {
            
            //ローカルアクセス用のパスを格納する変数
            var path: String = ""
            
            //棒グラフ
            if status == GraphStatus.BarGraph {
                
                path = NSBundle.mainBundle().pathForResource("barchart", ofType: "html")!
                
            //折れ線グラフ
            } else if status == GraphStatus.LineGraph {
                
                path = NSBundle.mainBundle().pathForResource("linechart", ofType: "html")!
                
            }
            
            let htmlFile = try String(contentsOfFile: path, encoding: NSUTF8StringEncoding)
            self.grachWebView.loadHTMLString(htmlFile, baseURL: NSURL(fileURLWithPath: NSBundle.mainBundle().bundlePath))
            self.grachWebView.scalesPageToFit = false
            
        } catch _ as NSError {
            
        }
        
    }

    //グラフの状態に応じてグラフデータを整形して読み込む
    func displayGraphBase(status: GraphStatus) {
        
        switch (status) {
            
            //棒グラフ
            case GraphStatus.BarGraph:
                self.displayBarGraphToWebView()
                break
            
            //折れ線グラフ
            case GraphStatus.LineGraph:
                self.displayLineGraphToWebView()
                break
        }
        
    }
    
    //棒グラフ用のデータを作成してWebViewへ描画（実装汚くてすみません...）
    func displayBarGraphToWebView() {
        
        if self.caloriesArrayForBarChart.count > 0 {
            
            //棒グラフ用の文字列を生成する
            var initBarChart: String
            
            if self.caloriesArrayForBarChart.count == 1 {
                
                let first: Calorie = self.caloriesArrayForBarChart[0] as! Calorie
                
                initBarChart = NSString(format:"drawBarChart(['%@','%@','%@'],[%@,%@,%@]);", first.food, "なし", "なし", String(first.amount), "0", "0") as String
                
            } else if self.caloriesArrayForBarChart.count == 2 {

                let first: Calorie = self.caloriesArrayForBarChart[0] as! Calorie
                let second: Calorie = self.caloriesArrayForBarChart[1] as! Calorie
                
                initBarChart = NSString(format:"drawBarChart(['%@','%@','%@'],[%@,%@,%@]);", first.food, second.food, "なし", String(first.amount), String(second.amount), "0") as String
                
            } else {
                
                let first: Calorie = self.caloriesArrayForBarChart[0] as! Calorie
                let second: Calorie = self.caloriesArrayForBarChart[1] as! Calorie
                let third: Calorie = self.caloriesArrayForBarChart[2] as! Calorie

                initBarChart = NSString(format:"drawBarChart(['%@','%@','%@'],[%@,%@,%@]);", first.food, second.food, third.food, String(first.amount), String(second.amount), String(third.amount)) as String
                
            }
            
            //ローカルWebviewのJavaScriptのメソッドをキックする
            self.grachWebView.stringByEvaluatingJavaScriptFromString(initBarChart)
            
        }

    }
    
    //折れ線グラフ用のデータを作成してWebViewへ描画（同じく汚いからエレガントに書きたい...）
    func displayLineGraphToWebView() {
        
        //TableViewに表示しているデータをそのまま使う
        if self.caloriesArrayForCell.count > 0 {
            
            //折れ線グラフ用の文字列を生成する
            var initLineChart: String
            
            if self.caloriesArrayForCell.count == 1 {
                
                let first: Calorie = self.caloriesArrayForCell[0] as! Calorie
                
                initLineChart = NSString(format:"drawLineChart(['%@','%@','%@'],[%@,%@,%@]);", first.food, "なし", "なし", String(first.amount), "0", "0") as String
                
            } else if self.caloriesArrayForCell.count == 2 {
                
                let first: Calorie = self.caloriesArrayForCell[0] as! Calorie
                let second: Calorie = self.caloriesArrayForCell[1] as! Calorie
                
                initLineChart = NSString(format:"drawLineChart(['%@','%@','%@'],[%@,%@,%@]);", first.food, second.food, "なし", String(first.amount), String(second.amount), "0") as String
                
            } else {
                
                let first: Calorie = self.caloriesArrayForCell[0] as! Calorie
                let second: Calorie = self.caloriesArrayForCell[1] as! Calorie
                let third: Calorie = self.caloriesArrayForCell[2] as! Calorie
                
                initLineChart = NSString(format:"drawLineChart(['%@','%@','%@'],[%@,%@,%@]);", first.food, second.food, third.food, String(first.amount), String(second.amount), String(third.amount)) as String
                
            }
            
            //ローカルWebviewのJavaScriptのメソッドをキックする
            self.grachWebView.stringByEvaluatingJavaScriptFromString(initLineChart)
            
        }
        
    }
    
    //セグメントコントロールで切り替え時に行われるアクション
    @IBAction func changeGraphDisplayAction(sender: UISegmentedControl) {
        
        switch (sender.selectedSegmentIndex) {
        
            case GraphStatus.BarGraph.returnValue():
                self.selectedGraph = GraphStatus.BarGraph
                self.loadLocalHtmlSource(self.selectedGraph)
                break
            
            case GraphStatus.LineGraph.returnValue():
                self.selectedGraph = GraphStatus.LineGraph
                self.loadLocalHtmlSource(self.selectedGraph)
                break
            
            default:
                self.selectedGraph = GraphStatus.BarGraph
                self.loadLocalHtmlSource(self.selectedGraph)
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

