//
//  ViewController.swift
//  music_timer
//
//  Created by 鶴田拓也 on 2015/04/10.
//  Copyright (c) 2015年 Takuya Tsuruda. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {

    var myUIPicker: UIPickerView = UIPickerView()
    var minArray:NSArray = NSArray()
    
    myUIPciker.frame = CGRectMake(0,0,view.bounds.width,250.0)
    myUIPicker.delegate = self
    myUiPicker.dataSource = self
    self.view.addSubview(myUIPicker)

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

