//
//  ViewController.swift
//  music_timer
//
//  Created by 鶴田拓也 on 2015/04/10.
//  Copyright (c) 2015年 Takuya Tsuruda. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //datePickerを作成する
        var myDatePicker:UIDatePicker = UIDatePicker()
        
        //datePickerの設定
        myDatePicker.datePickerMode = UIDatePickerMode.CountDownTimer
        
        
        //値が変わった際のイベント
        myDatePicker.addTarget(self,
            action: Selector("onDidChangedData:"),
            forControlEvents: UIControlEvents.ValueChanged)
        
        //DataPickerをViewに追加
        self.view.addSubview(myDatePicker)
        

    }
    
    @IBOutlet weak var myTextField: UILabel!
    
    //datePickerが変更された時に呼ばれる
    func onDidChangedData(sender:NSObject)
    {
        let myDateFormatter: NSDateFormatter = NSDateFormatter()
        myDateFormatter.dateFormat = "hh:mm"
        var mySelectedData: NSString = myDateFormatter.stringFromDate(sender.date)
        myTextField.text = mySelectedData
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

