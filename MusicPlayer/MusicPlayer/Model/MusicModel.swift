//
//  MusicModel.swift
//  MusicPlayer
//
//  Created by MoGo on 17/2/14.
//  Copyright © 2017年 李策--MoGo--. All rights reserved.
//

import UIKit

class MusicModel: NSObject {
    public var name : String?
    public var singer : String?
    public var singerIcon : String?
    public var lrcname : String?
    public var filename : String?
    public var icon : String?
    override init() {
        super.init()
    }
    init(dict:[String : AnyObject]) {
        super.init()
        self.setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
