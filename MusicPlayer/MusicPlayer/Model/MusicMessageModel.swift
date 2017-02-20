//
//  MusicMessageModel.swift
//  MusicPlayer
//
//  Created by MoGo on 17/2/14.
//  Copyright © 2017年 李策--MoGo--. All rights reserved.
//

import UIKit

class MusicMessageModel: NSObject {
    public var musicM : MusicModel!
    public var costTime : TimeInterval!
    public var costTimeFormat:String {
        get{
          return self.getFormatTime(time: costTime)
        }
    }
    public var totalTime : TimeInterval!
    public var totalTimeFormat : String{
        get{
            return self.getFormatTime(time: self.totalTime)
        }
    }
    public var playing = true
    
    func getFormatTime(time:TimeInterval) -> String {
        let min = NSInteger.init(time)/60
        let sec = NSInteger.init(time) - min * 60
        
       return String.init(format: "%02ld:%02ld", arguments: [min,sec])
    }
}
