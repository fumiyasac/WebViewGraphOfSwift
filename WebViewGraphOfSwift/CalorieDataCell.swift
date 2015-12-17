//
//  CalorieDataCell.swift
//  WebViewGraphOfSwift
//
//  Created by 酒井文也 on 2015/12/17.
//  Copyright © 2015年 just1factory. All rights reserved.
//

import UIKit

class CalorieDataCell: UITableViewCell {

    //画面に配置された部品
    @IBOutlet var calorieImage: UIImageView!
    @IBOutlet var calorieTitle: UILabel!
    @IBOutlet var calorieDate: UILabel!
    @IBOutlet var calorieValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
