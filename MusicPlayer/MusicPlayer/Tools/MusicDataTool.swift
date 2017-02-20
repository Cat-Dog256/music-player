//
//  MusicDataTool.swift
//  MusicPlayer
//
//  Created by MoGo on 17/2/13.
//  Copyright © 2017年 李策--MoGo--. All rights reserved.
//

import UIKit

class MusicDataTool: NSObject {
    public static func getMusicList(fileName:String , result:(_ Array : [MusicModel])->Void) -> Void {
       let path = Bundle.main.path(forResource: fileName, ofType: nil)
        if path == nil{
            result(Array.init())
            return
        }
        let list = NSArray.init(contentsOfFile: path!)
        if list == nil{
            result(Array.init())
            return
        }
        
        var modelsArray:[MusicModel] = Array.init()
        
        list?.enumerateObjects({ (obj, index, stop) in
            let dict :[String : AnyObject] = obj as! [String : AnyObject]
            
            let model = MusicModel.init(dict: dict)
            
            modelsArray.append(model)
        })
        result(modelsArray);
    }
}
