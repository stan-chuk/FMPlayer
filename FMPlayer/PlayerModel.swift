//
//  PlayerModel.swift
//  FMPlayer
//
//  Created by 祝韶明 on 16/5/7.
//  Copyright © 2016年 祝韶明. All rights reserved.
//

import Foundation

class PlayerModel: NSObject {
    
    private let channelUrl = NSURL(string: "https://www.douban.com/j/app/radio/channels")
    
    //频道名列表
    private var channelList: NSDictionary = [:]
    
    func getChannel() -> NSDictionary {
        let channelData = NSData(contentsOfURL: channelUrl!)
        do {
            let json: NSDictionary = try NSJSONSerialization.JSONObjectWithData(channelData!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
            self.channelList = json
        } catch let error as NSError {
            print("\(error.domain)")
        }
        return self.channelList
    }
}