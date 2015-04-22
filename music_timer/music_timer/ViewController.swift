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
        
        //画面サイズを取得
        let myBoundSize: CGSize = UIScreen.mainScreen().bounds.size
        
        myUIPicker.frame = CGRectMake(0,myBoundSize.height/20,view.bounds.width,myBoundSize.height/4)
        myUIPicker.delegate = self
        myUIPicker.dataSource = self
        self.view.addSubview(myUIPicker)
        
        var test1:makeArray = makeArray()
        test1.hoge()

        //YouTubeの動画再生
        var url:NSURL = NSURL(string: "https://www.youtube.com/watch?v=Zbs51D2wwkc")!
        var dict = HCYoutubeParser.h264videosWithYoutubeURL(url)
        var url2 = NSURL(string: dict["medium"] as! String)
        self.moviePlayer = MPMoviePlayerController(contentURL: url2)
        self.moviePlayer.view.frame = CGRect(x:0, y:myBoundSize.height/2, width:self.view.frame.width, height:myBoundSize.height/2)
        self.view.addSubview(moviePlayer.view)
        
        self.moviePlayer.fullscreen = true
        self.moviePlayer.controlStyle = MPMovieControlStyle.Embedded
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
    //dataをパースしてvideoIDを取得する
    func onSearchComplete(data:NSData) -> [String]
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
        return returnArray
    }
    func onSearchFail(){
        println("error")
    }

    //durationを取得するurlを作る
    func makeParamertar(videoid:String) -> String {
        var dict:Dictionary = ["part":"contentDetails","key" : "AIzaSyA30dmMDdAU8-jKvY9tilTpp4iTvnjXt_c","id":"\(videoid)"]
        var param = stringFromHttpParameters(dict)
        var allurl:String = "https://www.googleapis.com/youtube/v3/videos?" + param
        return allurl
    }
    //durationDataの取得
    func getDurationData(durationAllURL:String) -> String {
        //durations取得のurlのインスタンスを作成
        var durationURL = NSURL(string: durationAllURL)
        //durations取得のリクエストを作成
        var durationRequest = NSMutableURLRequest(URL: durationURL!)
        durationRequest.HTTPMethod = "GET"

        var duration:String = ""
        var durationtask = NSURLSession.sharedSession().dataTaskWithRequest(durationRequest, completionHandler: {
            durationData, response, error in
            if (error == nil){
                duration = self.onParseDuration(durationData)
            }else{
                println("error")
            }
        })
        durationtask.resume()
        
        return duration
    }
    //durationDataをパースしてdurationを取得
    func onParseDuration(durationData:NSData)  -> String{
        var durationString:String = NSString(data:durationData, encoding:NSUTF8StringEncoding) as! String
        var result:JSON = JSON.parse(durationString)
        var duration:String = ""
        if var items:[JSON] = result["items"].asArray {
            var item = items[0]
            var contentDetails = item["contentDetails"]
            duration = contentDetails["duration"].asString!
        }
        return duration
    }
    
    
    @IBAction func getJsonData(sender: AnyObject) {
        
        //パラメータを作成してURLを作成
        var dict:Dictionary = ["part": "snippet", "q": "乃木坂","key" : "AIzaSyA30dmMDdAU8-jKvY9tilTpp4iTvnjXt_c","type":"video","maxResults":"50","videoDuration":"short"]
        var param = stringFromHttpParameters(dict)
        var allurl:String = "https://www.googleapis.com/youtube/v3/search?" + param
        
//        var xmlURL = "http://gdata.youtube.com/feeds/api/videos/"
        
        //urlのインスタンスを生成
        var url = NSURL(string: allurl)
        //リクエストを生成
        var request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "GET"

        //リクエストを飛ばしてjsonデータを取得  非同期処理
        var task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: {
            data, response, error in
            if (error == nil){
                var videoid:[String] = self.onSearchComplete(data)
                //得られた動画の長さを取得
                var durationAllURL:[String] = []
                var len = durationAllURL.count
                for var j=0; j<len; j++ {
                    var durationAllURL:String = self.makeParamertar(videoid[j])
                    var duration:String = self.getDurationData(durationAllURL)
                    println()
                }
            }else{
                self.onSearchFail()
            }
        })
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

