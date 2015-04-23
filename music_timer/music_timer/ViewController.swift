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
    
    var min:String = ""
    var sec:String = ""
    
    var checker:Bool = true
    
    var pageNumber:Int = 0
    
    var totalCount:Int = 0
    var loadedCount:Int = 0
    
    var isOk:Bool = false
    
    var nextPageToken:String = ""
    
    var videoId:String = ""
    
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
        
    }
    func youtubeLoad(videoId:String){
        let myBoundSize: CGSize = UIScreen.mainScreen().bounds.size
        //YouTubeの動画再生
        var url:NSURL = NSURL(string: "https://www.youtube.com/watch?v=\(videoId)")!
        var dict = HCYoutubeParser.h264videosWithYoutubeURL(url)
        var url2 = NSURL(string: dict["medium"] as! String)
        self.moviePlayer = MPMoviePlayerController(contentURL: url2)
        self.moviePlayer.view.frame = CGRect(x:0, y:myBoundSize.height/2, width:self.view.frame.width, height:myBoundSize.height/2)
        self.view.addSubview(moviePlayer.view)
        
//        self.moviePlayer.fullscreen = true
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
            min = minArray[row].description
            self.pageNumber = 0
            self.checker = true
            println("列\(row)")
            println("値\(minArray[row])")
        }else if(component == 1){
            sec = secArray[row].description
            self.pageNumber = 0
            self.checker = true
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
//                println(videoId.toString())
            }
        }
        return returnArray
    }
    func onSearchFail(){
        println("error")
    }
    //dataをパースしてvideoTokenを取得
    func onSearchVideoToken(data:NSData) -> String{
        var tokenString:String = ""
        //NSDataをNSStringにする
        var jsonString:String = NSString(data:data, encoding:NSUTF8StringEncoding) as! String
        //jsonデータをパースする
        var result:JSON = JSON.parse(jsonString)
        var nextPageToken:JSON = result["nextPageToken"]
        var token:String? = nextPageToken.asString
        if token != nil{
            tokenString = token!
        }
        return tokenString
    }

    //durationを取得するurlを作る
    func makeParamertar(videoid:String) -> String {
        var dict:Dictionary = ["part":"contentDetails","key" : "AIzaSyA30dmMDdAU8-jKvY9tilTpp4iTvnjXt_c","id":"\(videoid)"]
        var param = stringFromHttpParameters(dict)
        var allurl:String = "https://www.googleapis.com/youtube/v3/videos?" + param
        return allurl
    }
        //durationDataを取得してdurationを取得
    func onParseDuration(durationData:NSData) -> String {
        var durationString:String = NSString(data:durationData, encoding:NSUTF8StringEncoding) as! String
        var duration:String = ""
        println(durationString)
        var result:JSON = JSON.parse(durationString)
        if var items:[JSON] = result["items"].asArray {
            var item = items[0]
            var contentDetails = item["contentDetails"]
            duration = contentDetails["duration"].asString!
        }
        return duration
    }
    
    
    @IBAction func onClickGetButton(sender: AnyObject) {
//        self.youtubeLoad("KV-FJ7k_3pY")
        self.requestYoutubeSearch("")
    }
    func requestYoutubeSearch(nextPageToken:String) {
        //パラメータを作成してURLを作成
        var dict:Dictionary = [String:String]()
        if nextPageToken == "" {
            dict = ["part": "snippet", "q": "乃木坂","key" : "AIzaSyA30dmMDdAU8-jKvY9tilTpp4iTvnjXt_c","type":"video","maxResults":"50","videoDuration":"medium"]
        }else{
            dict = ["part": "snippet", "q": "乃木坂","key" : "AIzaSyA30dmMDdAU8-jKvY9tilTpp4iTvnjXt_c","type":"video","maxResults":"50","videoDuration":"medium","pageToken":"\(nextPageToken)"]
        }
        var param = stringFromHttpParameters(dict)
        var allurl:String = "https://www.googleapis.com/youtube/v3/search?" + param
    
        //urlのインスタンスを生成
        var url = NSURL(string: allurl)
        //リクエストを生成
        var request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "GET"
    
        //リクエストを飛ばしてjsonデータを取得  非同期処理
        var task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: {
            data, response, error in
            if (error == nil){
                self.youtubeSearchComplete(data)
            }else{
                self.onSearchFail()
            }
        })
        task.resume()
    }
    
    func youtubeSearchComplete(data:NSData){
        var videoid:[String] = self.onSearchComplete(data)
        self.nextPageToken = self.onSearchVideoToken(data)
        //得られた動画の長さを取得
        var durationAllURL:[String] = []
        var len = videoid.count
        for_b : for var j=0; j<len; j++ {
            var durationAllURL:String = self.makeParamertar(videoid[j])
            self.loadDurationData(durationAllURL)
        }
//        self.pageNumber++   //ページを変える
    }
    //durationDataの取得
    func loadDurationData(durationAllURL:String) {
        self.totalCount++
        //durations取得のurlのインスタンスを作成
        var durationURL = NSURL(string: durationAllURL)
        //durations取得のリクエストを作成
        var durationRequest = NSMutableURLRequest(URL: durationURL!)
        durationRequest.HTTPMethod = "GET"
        var duration:String = ""
        var durationtask = NSURLSession.sharedSession().dataTaskWithRequest(durationRequest, completionHandler: {
            durationData, response, error in
            if (error == nil){
                self.loadDurationDataComplete(durationData)
            }else{
                println("error")
            }
        })
        durationtask.resume()
        
    }
    func loadDurationDataComplete(data:NSData){
        self.loadedCount++
        var duration = self.onParseDuration(data)  //パースする
        var videoId = self.getVideoId(data)
        if self.checkDuration(duration) {
            self.isOk = true
            self.videoId = videoId
        }
        if self.loadedCount == self.totalCount {
            self.onAllLodaComplete()
        }
    }
    func getVideoId(data:NSData) -> String{
        var durationString:String = NSString(data:data, encoding:NSUTF8StringEncoding) as! String
        var videoId:String = ""
        println(durationString)
        var result:JSON = JSON.parse(durationString)
        if var items:[JSON] = result["items"].asArray {
            var item = items[0]
            videoId = item["id"].asString!
        }
        return videoId

    }
    func onAllLodaComplete(){
        if self.isOk {
            self.findedVideoId()
        }else if self.pageNumber < 4 {
            self.pageNumber++   //ページを変える
            self.requestYoutubeSearch(self.nextPageToken)
        }
    }
    func findedVideoId(){
        println("ビデオが見つかったのでyoutubeを再生")
        self.youtubeLoad(self.videoId)   //YouTubeを再生
    }
    func checkDuration(duration:String) -> Bool{
        //欲しい長さの動画が見つかった時はcheckerをfalseにする
        if duration == "PT\(self.min)M\(self.sec)S" {
            return true
        }else if duration == "PT\(self.min)M" {
            return true
        }else if  duration == "PT\(self.sec)S" {
            return true
        }
        return false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

