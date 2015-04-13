//
//  ViewController.swift
//  music_timer
//
//  Created by 鶴田拓也 on 2015/04/10.
//  Copyright (c) 2015年 Takuya Tsuruda. All rights reserved.
//

import UIKit


class ViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {

    func makeArray(inout array:[Int]) {
        for var i = 0 ; i<60 ; i++ {
            array[i] = i+1
        }
    }
    
    var myUIPicker: UIPickerView = UIPickerView()
    
    var minArray:NSArray = ["1"]
    makeArray(&minArray)
    var secArray:NSArray = ["1","2","3","4","5","6","7"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        myUIPicker.frame = CGRectMake(0,0,view.bounds.width,250.0)
        myUIPicker.delegate = self
        myUIPicker.dataSource = self
        self.view.addSubview(myUIPicker)
    }
    
    //表示例
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2 
    }
    
    //表示個数
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(component == 0){
            return minArray.count
        }else if(component == 1){
            return secArray.count
        }
        return 0;
    }
    
    //表示内容
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if(component == 0){
            return minArray[row] as String
        }else if(component == 1){
            return secArray[row] as String
        }
        return "";
    }
    
    //選択時
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(component == 0){
            println("列\(row)")
            println("値\(minArray[row])")
        }else if(component == 1){
            println("列\(row)")
            println("値\(secArray[row])")
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

