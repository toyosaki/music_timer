//
//  ViewController.swift
//  music_timer
//
//  Created by 鶴田拓也 on 2015/04/10.
//  Copyright (c) 2015年 Takuya Tsuruda. All rights reserved.
//

import UIKit
import makeArrayFramework
import MediaPlayer


class ViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {
    
    var moviePlayer:MPMoviePlayerController!
    
    var myUIPicker: UIPickerView = UIPickerView()
    
    var minArray:NSArray = makeArray.make();
    var secArray:NSArray = makeArray.make();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        myUIPicker.frame = CGRectMake(0,0,view.bounds.width,250.0)
        myUIPicker.delegate = self
        myUIPicker.dataSource = self
        self.view.addSubview(myUIPicker)
        
        var test1:makeArray = makeArray()
        test1.hoge()

        var url:NSURL = NSURL(string: "https://www.youtube.com/watch?v=Zbs51D2wwkc")!
        var dict = HCYoutubeParser.h264videosWithYoutubeURL(url)
        self.moviePlayer = MPMoviePlayerController(contentURL: url)
        self.moviePlayer.view.frame = CGRect(x:0, y:0, width:self.view.frame.width, height:self.view.frame.height)
        self.view.addSubview(moviePlayer.view)
        
        self.moviePlayer.fullscreen = true
        self.moviePlayer.controlStyle = MPMovieControlStyle.None
        self.moviePlayer.shouldAutoplay = true
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
            return minArray[row].description  //数値からstring　型変換
        }else if(component == 1){
            return secArray[row].description  //数値からstring 型変換
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
    
    //パラメータを作成する関数
    func stringByAddingPercentEncodingForURLQueryValue(value:AnyObject) -> String? {
        let characterSet = NSMutableCharacterSet.alphanumericCharacterSet()
        characterSet.addCharactersInString("-._~")
        var str:String = "\(value)"
        return str.stringByAddingPercentEncodingWithAllowedCharacters(characterSet)
    }
    func stringFromHttpParameters( dict:Dictionary<String, AnyObject> ) -> String
    {
        let parameterArray = map(dict) { (key, value) -> String in
            let percentEscapedKey = self.stringByAddingPercentEncodingForURLQueryValue(key)!
            let percentEscapedValue = self.stringByAddingPercentEncodingForURLQueryValue(value)!
            return "\(percentEscapedKey)=\(percentEscapedValue)"
        }
        
        return join("&", parameterArray)
    }
    //
    func onSearchComplete(data:NSData)
    {
        //返値用の配列
        var returnArray:[String] = []
        //NSDataをNSStringにする
        var jsonString:String = NSString(data:data, encoding:NSUTF8StringEncoding) as! String
        //jsonデータをパースする
        var result:JSON = JSON.parse(jsonString)
        if var items:[JSON] = result["items"].asArray {
            var len:Int = items.count
            for var i=0; i<len; i++ {
                var item = items[i]
                var id = item["id"]
                var videoId = id["videoId"]
                returnArray.append(videoId.asString!)
                println(videoId.toString())
            }
        }
        //return returnArray
    }
    func onSearchFail(){
        println("error")
    }

    func makeXMLurl(){
        
    }
    
    
    @IBAction func getJsonData(sender: AnyObject) {
        
        //パラメータを作成してURLを作成 　　　順番は気にしなくていいのかな？
        var dict:Dictionary = ["part": "snippet", "q": "乃木坂","key" : "AIzaSyA30dmMDdAU8-jKvY9tilTpp4iTvnjXt_c","type":"video","maxResults":"50","videoDuration":"any"]
        var param = stringFromHttpParameters(dict)
        var allurl:String = "https://www.googleapis.com/youtube/v3/search?" + param
        
        var xmlURL = "http://gdata.youtube.com/feeds/api/videos/"
        
        //urlのインスタンスを生成
        var url = NSURL(string: allurl)
        //リクエストを生成
        var request = NSMutableURLRequest(URL: url!)
        
        request.HTTPMethod = "GET"

        //リクエストを飛ばしてjsonデータを取得
        var task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: {
            data, response, error in
            if (error == nil){
                self.onSearchComplete(data)
            }else{
                self.onSearchFail()
            }
        })
        task.resume()
        
//
//            
//            
//        }
    }
    
//        //リクエストを飛ばしてjsonデータを取得
//        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)
//        //パースする
//        var json:NSDictionary = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: nil) as! NSDictionary
//        
//        var pond: AnyObject = json["pond"]!
//        var value1:AnyObject = pond[0]
//        var value11:String = (value1["user_id"] as? String)!
//        var value12:String = (value1["name"] as? String)!
//        var value13:Int = value1["status"] as! Int
//        var value14:Int = value1["float"] as! Int
//        
//        
//        var info:String =  value11 + "\n" + value12 + "\n" + String(value13) + "\n" + String(value14) + "\n"
//        jsonTextView.text = info
        

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

