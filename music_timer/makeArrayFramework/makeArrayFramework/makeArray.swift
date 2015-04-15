//
//  makeArray.swift
//  makeArrayFramework
//
//  Created by tsuruda on 2015/04/13.
//  Copyright (c) 2015年 tsuruda. All rights reserved.
//

import Foundation
public class makeArray{
    
    public class func make() -> NSArray
    {
        var array:[Int] = [0];
        for var i = 1 ; i<60 ; i++ {
             array.append(i)
        }
        return array
    }
    
    public func hoge(){
        println("hoge!!!")
    }

    public init(){
//        making.makeArray()
    }
}