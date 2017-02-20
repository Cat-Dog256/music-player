//
//  MusicLrcModel.swift
//  MusicPlayer
//
//  Created by MoGo on 17/2/16.
//  Copyright © 2017年 李策--MoGo--. All rights reserved.
//

import UIKit

class MusicLrcModel: NSObject {
    public var beginTime : TimeInterval = 0.0;
    public var endTIme : TimeInterval = 0.0;
    public var lrcStr : String = " "
    override var description: String{
        return String.init(format: "\nbeginTime:%f\nendTIme:%f\nlrcStr:%@\n", self.beginTime,self.endTIme,self.lrcStr)
    }
}
