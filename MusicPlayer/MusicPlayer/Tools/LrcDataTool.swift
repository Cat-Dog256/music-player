//
//  LrcDataTool.swift
//  MusicPlayer
//
//  Created by MoGo on 17/2/16.
//  Copyright © 2017年 李策--MoGo--. All rights reserved.
//

import UIKit

class LrcDataTool: NSObject {
    static func getLrcData(fileName : String , totalTime : TimeInterval) -> [MusicLrcModel] {
        
        
        let path : String? = Bundle.main.path(forResource: fileName, ofType: nil);
        if path == nil {
            return [];
        }
        var lrcText = ""
        
        do {
            try lrcText = String.init(contentsOfFile: path!)
        } catch{
            return [];
        }
        
        let list = lrcText.components(separatedBy: "\n")
        var lrcMs : [MusicLrcModel] = []
        
        list.forEach { (aStr) in
            var lrcStr = aStr
            let isNoUseData = lrcStr.contains("[ti:") || lrcStr.contains("[ar:") || lrcStr.contains("[al:")
            if isNoUseData == false{
                let model = MusicLrcModel.init()
                
                lrcMs.append(model)
                if lrcStr.contains("]"){
                    lrcStr.remove(at: lrcStr.startIndex)
                }
                let lrcContents = lrcStr.components(separatedBy: "]")
                
                if lrcContents.count == 2{
                    let time = lrcContents[0]
                    model.beginTime = LrcDataTool.getTimeInterval(formatTime: time)
                    
                    model.lrcStr =  lrcContents[1]
                    
                    
                }
            }
        }
        
        for i in 0..<lrcMs.count{
            let model = lrcMs[i]

            if i < lrcMs.count - 1 {
                model.endTIme = lrcMs[i + 1].beginTime
            } else {
                model.endTIme = totalTime
            }
            
        }
        return lrcMs
    }
    static func getRowLrc(currentTime:TimeInterval , lrcMs:[MusicLrcModel] , completion:(_ row:NSInteger , _ lrcModel:MusicLrcModel)->Void) -> Void{
        var index = 0
        var resultM : MusicLrcModel!
        
        
        for i in 0..<lrcMs.count{
            let model = lrcMs[i]
            if currentTime >= model.beginTime && currentTime <= model.endTIme {
                index = i
                resultM = model
                break
            }
        }
        completion(index , resultM)
    }
    fileprivate static func getTimeInterval(formatTime:String) -> TimeInterval {
        let times = formatTime.components(separatedBy: ":")
        let min : Double = Double.init(times[0])!
        
        let sec : Double = Double.init(times[1])!
        
        return min * 60 + sec

    }
}
