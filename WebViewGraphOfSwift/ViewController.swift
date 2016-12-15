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
    
    override func viewWillAppear(_ animated: Bool) {
        fetchAndReloadData()
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
        grachWebView.delegate = self
        
        //TableViewのデリゲート設定
        recordTableView.delegate = self
        recordTableView.dataSource = self
        
        //Xibのクラスを読み込む宣言を行う
        let nibDefault:UINib = UINib(nibName: "CalorieDataCell", bundle: nil)
        recordTableView.register(nibDefault, forCellReuseIdentifier: "CalorieDataCell")
        
    }
    
    //各データのfetchとテーブルビューのリロードを行う
    func fetchAndReloadData() {
        
        //カロリーデータをフェッチしてTableViewへの一覧表示用のデータを作成
        //※折れ線グラフでも使う
        caloriesArrayForCell.removeAllObjects()
        let calories = Calorie.fetchAllCalorieListSortByDate()
        
        cellCount = calories.count
        
        if cellCount != 0 {
            for calorie in calories {
                caloriesArrayForCell.add(calorie)
            }
        }
        
        //棒グラフ用の可変配列の作成
        caloriesArrayForBarChart.removeAllObjects()
        let caloriesForBarChart = Calorie.fetchAllCalorieListSortByAmount()
        if caloriesForBarChart.count != 0 {
            for calorieForBarChart in caloriesForBarChart {
                caloriesArrayForBarChart.add(calorieForBarChart)
            }
        }
        
        //テーブルビューをリロード
        reloadData()
        
        //セグメントコントロール位置の初期設定
        selectGraphSegment.selectedSegmentIndex = 0
        
        //グラフの初期状態を設定する
        selectedGraph = GraphStatus.barGraph
        
        //ローカルhtmlを読み込む
        loadLocalHtmlSource(selectedGraph)
    }
    
    //TableView: テーブルの要素数を設定する
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionCount
    }
    
    //TableView: テーブルのセクションのセル数を設定する
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCount
    }
    
    //TableView: Editableの状態にする.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //TableView: 特定の行のボタン操作を有効にする.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        print("commitEdittingStyle:\(editingStyle)")
    }
    
    //TableView: Buttonを拡張＆データ削除処理
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        //削除ボタン
        let myDeleteButton: UITableViewRowAction = UITableViewRowAction(style: .normal, title: "削除") { (action, index) -> Void in
            
            //テーブルビューを編集不可にする
            tableView.isEditing = false
            
            //データを1件削除
            let calorieData: Calorie = self.caloriesArrayForCell[(indexPath as NSIndexPath).row] as! Calorie
            calorieData.delete()
            
            //データをリロードする
            self.fetchAndReloadData()
            
        }
        myDeleteButton.backgroundColor = UIColor.red
        return [myDeleteButton]
    }
    
    //TableView: 表示するセルの中身を設定する
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Xibファイルを元にデータを作成する
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieDataCell") as? CalorieDataCell
        
        //テキスト・画像等の表示
        let calorieData: Calorie = self.caloriesArrayForCell[(indexPath as NSIndexPath).row] as! Calorie
        
        cell!.calorieTitle.text = calorieData.food
        cell!.calorieValue.text = String(calorieData.amount) + "kcal"
        
        //NSDate型は文字列に変換
        let eatDateString: String = ChangeDateOrString.convertDateToString(calorieData.eatDate)
        cell!.calorieDate.text = eatDateString
        
        //画像を表示させる
        cell!.calorieImage.image = calorieData.image

        //セルのアクセサリタイプと背景の設定
        cell!.accessoryType = UITableViewCellAccessoryType.none
        cell!.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell!
    }
    
    //TableView: セルをタップした時に呼び出される
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //@todo: go some controller...
    }
    
    //TableView: セルの高さを返す
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    //TableView: テーブルビューをリロードする
    func reloadData(){
        recordTableView.reloadData()
    }
    
    //WebView: ローカルのHTMLファイルのロードが完了したら実行される
    func webViewDidFinishLoad(_ webView: UIWebView) {
        displayGraphBase(selectedGraph)
    }
    
    //ローカルのhtmlファイルを読み込む
    func loadLocalHtmlSource(_ status: GraphStatus) {
        
        //htmlファイルへアクセスする
        do {
            
            //ローカルアクセス用のパスを格納する変数
            var path: String = ""
            
            //棒グラフ
            if status == GraphStatus.barGraph {
                
                path = Bundle.main.path(forResource: "barchart", ofType: "html")!
                
            //折れ線グラフ
            } else if status == GraphStatus.lineGraph {
                
                path = Bundle.main.path(forResource: "linechart", ofType: "html")!
                
            }
            
            let htmlFile = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
            grachWebView.loadHTMLString(htmlFile, baseURL: URL(fileURLWithPath: Bundle.main.bundlePath))
            grachWebView.scalesPageToFit = false
            
        } catch _ as NSError {
            
        }
        
    }

    //グラフの状態に応じてグラフデータを整形して読み込む
    func displayGraphBase(_ status: GraphStatus) {
        
        switch (status) {
            
            //棒グラフ
            case GraphStatus.barGraph:
                self.displayBarGraphToWebView()
                break
            
            //折れ線グラフ
            case GraphStatus.lineGraph:
                self.displayLineGraphToWebView()
                break
        }
        
    }
    
    //棒グラフ用のデータを作成してWebViewへ描画（実装汚くてすみません...）
    func displayBarGraphToWebView() {
        
        if caloriesArrayForBarChart.count > 0 {
            
            //棒グラフ用の文字列を生成する
            var initBarChart: String
            
            if caloriesArrayForBarChart.count == 1 {
                
                let first: Calorie = caloriesArrayForBarChart[0] as! Calorie
                
                initBarChart = NSString(format:"drawBarChart(['%@','%@','%@'],[%@,%@,%@]);", first.food, "なし", "なし", String(first.amount), "0", "0") as String
                
            } else if self.caloriesArrayForBarChart.count == 2 {

                let first: Calorie = caloriesArrayForBarChart[0] as! Calorie
                let second: Calorie = caloriesArrayForBarChart[1] as! Calorie
                
                initBarChart = NSString(format:"drawBarChart(['%@','%@','%@'],[%@,%@,%@]);", first.food, second.food, "なし", String(first.amount), String(second.amount), "0") as String
                
            } else {
                
                let first: Calorie = caloriesArrayForBarChart[0] as! Calorie
                let second: Calorie = caloriesArrayForBarChart[1] as! Calorie
                let third: Calorie = caloriesArrayForBarChart[2] as! Calorie

                initBarChart = NSString(format:"drawBarChart(['%@','%@','%@'],[%@,%@,%@]);", first.food, second.food, third.food, String(first.amount), String(second.amount), String(third.amount)) as String
                
            }
            
            //ローカルWebviewのJavaScriptのメソッドをキックする
            grachWebView.stringByEvaluatingJavaScript(from: initBarChart)
            
        }

    }
    
    //折れ線グラフ用のデータを作成してWebViewへ描画（同じく汚いからエレガントに書きたい...）
    func displayLineGraphToWebView() {
        
        //TableViewに表示しているデータをそのまま使う
        if caloriesArrayForCell.count > 0 {
            
            //折れ線グラフ用の文字列を生成する
            var initLineChart: String
            
            if caloriesArrayForCell.count == 1 {
                
                let first: Calorie = caloriesArrayForCell[0] as! Calorie
                
                initLineChart = NSString(format:"drawLineChart(['%@','%@','%@'],[%@,%@,%@]);", first.food, "なし", "なし", String(first.amount), "0", "0") as String
                
            } else if self.caloriesArrayForCell.count == 2 {
                
                let first: Calorie = caloriesArrayForCell[0] as! Calorie
                let second: Calorie = caloriesArrayForCell[1] as! Calorie
                
                initLineChart = NSString(format:"drawLineChart(['%@','%@','%@'],[%@,%@,%@]);", first.food, second.food, "なし", String(first.amount), String(second.amount), "0") as String
                
            } else {
                
                let first: Calorie = caloriesArrayForCell[0] as! Calorie
                let second: Calorie = caloriesArrayForCell[1] as! Calorie
                let third: Calorie = caloriesArrayForCell[2] as! Calorie
                
                initLineChart = NSString(format:"drawLineChart(['%@','%@','%@'],[%@,%@,%@]);", first.food, second.food, third.food, String(first.amount), String(second.amount), String(third.amount)) as String
                
            }
            
            //ローカルWebviewのJavaScriptのメソッドをキックする
            grachWebView.stringByEvaluatingJavaScript(from: initLineChart)
            
        }
        
    }
    
    //セグメントコントロールで切り替え時に行われるアクション
    @IBAction func changeGraphDisplayAction(_ sender: UISegmentedControl) {
        
        switch (sender.selectedSegmentIndex) {
        
            case GraphStatus.barGraph.returnValue():
                selectedGraph = GraphStatus.barGraph
                loadLocalHtmlSource(selectedGraph)
                break
            
            case GraphStatus.lineGraph.returnValue():
                selectedGraph = GraphStatus.lineGraph
                loadLocalHtmlSource(selectedGraph)
                break
            
            default:
                selectedGraph = GraphStatus.barGraph
                loadLocalHtmlSource(selectedGraph)
                break
        }
        
    }
    
    //次のページに遷移するアクション
    @IBAction func goAddCalorieAction(_ sender: UIButton) {
        
        //詳細データを遷移先へ引き渡す処理（AddControllerのStoryBoardID：Add）
        let addController: AddController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Add") as! AddController
        self.present(addController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

