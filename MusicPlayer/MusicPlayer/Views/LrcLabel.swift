//
//  LrcLabel.swift
//  MusicPlayer
//
//  Created by MoGo on 17/2/16.
//  Copyright © 2017年 李策--MoGo--. All rights reserved.
//

import UIKit

class LrcLabel: UILabel {
    private var isOrange = false
    public var progress : CGFloat = 0{
        didSet{
            self.setNeedsDisplay()
        }
    }
    func resetDisplayColor() -> Void {
         isOrange = true
        self.setNeedsDisplay()
    }
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        super.draw(rect)
        if self.isOrange == true {
            UIColor.black.set()
            UIRectFillUsingBlendMode(rect, CGBlendMode.sourceIn)
            self.isOrange = false
        }else{
            UIColor.orange.set()
            let orangeRect = CGRect.init(x: rect.origin.x, y: rect.origin.y, width: rect.size.width * self.progress, height: rect.size.height)
            UIRectFillUsingBlendMode(orangeRect, CGBlendMode.sourceIn)
         }
      
    }
 

}
