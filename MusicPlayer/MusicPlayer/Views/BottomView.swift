//
//  BottomView.swift
//  MusicPlayer
//
//  Created by MoGo on 17/2/15.
//  Copyright © 2017年 李策--MoGo--. All rights reserved.
//

import UIKit

class BottomView: UIView {
    typealias btnEvent = (_ btn:UIButton)->Void
    let preBtn = UIButton.init()
    let curTimeL = UILabel.init()
    let tolTimeL = UILabel.init()
    let nextBtn = UIButton.init()
    let playBtn = UIButton.init()
    let progressSlider = UISlider.init()

    private var playEnt : btnEvent?
    private var preEnt : btnEvent?
    private var nextEnt : btnEvent?
    @objc private func preAction(_ sender: UIButton) {
        self.playBtn.isSelected = true
        self.preEnt?(sender)
    }
    @objc private func nextAction(_ sender: UIButton) {
        
        self.playBtn.isSelected = true
        self.nextEnt?(sender)
    }
    @objc private func playAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.playEnt?(sender)
    }
    func playEvent(block:btnEvent?) -> Void {
        self.playEnt = block
    }
    func nextEvent(block:btnEvent?) -> Void {
        self.nextEnt = block
    }
    func preEvent(block:btnEvent?) -> Void {
        self.preEnt = block
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.curTimeL)
        self.curTimeL.textAlignment = .center
        self.curTimeL.font = UIFont.systemFont(ofSize: 12)
        
        
        self.addSubview(self.progressSlider)
        self.progressSlider.setThumbImage(UIImage.init(named: "player_slider_playback_thumb"), for: UIControlState.normal)
        self.progressSlider.setThumbImage(UIImage.init(named: "player_slider_playback_thumb"), for: UIControlState.highlighted)
        self.progressSlider.tintColor = UIColor.green

        self.addSubview(self.tolTimeL)
        self.tolTimeL.textAlignment = .center
        self.tolTimeL.font = UIFont.systemFont(ofSize: 12)

        
        self.addSubview(self.preBtn)
        self.preBtn.addTarget(self, action: #selector(preAction(_:)), for: UIControlEvents.touchUpInside)
        self.preBtn.setImage(UIImage.init(named: "player_btn_pre_normal"), for: UIControlState.normal)
        self.preBtn.setImage(UIImage.init(named: "player_btn_pre_highlight"), for: UIControlState.highlighted)
        
        
        self.addSubview(self.playBtn)
        self.playBtn.isSelected = true
        self.playBtn.addTarget(self, action: #selector(playAction(_:)), for: UIControlEvents.touchUpInside)
        self.playBtn.setImage(UIImage.init(named: "player_btn_pause_normal"), for: UIControlState.selected)
        self.playBtn.setImage(UIImage.init(named: "player_btn_play_normal"), for: UIControlState.highlighted)
        self.playBtn.setImage(UIImage.init(named: "player_btn_play_normal"), for: UIControlState.normal)
        
        
        self.addSubview(self.nextBtn)
        self.nextBtn.addTarget(self, action: #selector(nextAction(_:)), for: UIControlEvents.touchUpInside)
        self.nextBtn.setImage(UIImage.init(named: "player_btn_next_normal"), for: UIControlState.normal)
        self.nextBtn.setImage(UIImage.init(named: "player_btn_next_highlight"), for: UIControlState.highlighted)
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let bv_W = self.frame.size.width
        let bv_H = self.frame.size.height
        let bv_M : CGFloat = 8
        let bv_Sh : CGFloat = 30
        let bv_Lw : CGFloat = 40
        
        self.curTimeL.frame = CGRect.init(x: bv_M, y: 0, width: bv_Lw, height: bv_Sh)
        self.tolTimeL.frame = CGRect.init(x: bv_W - bv_M - bv_Lw, y: 0, width: bv_Lw, height: bv_Sh)
        self.progressSlider.frame = CGRect.init(x: bv_M + bv_Lw + bv_M/2, y: 0, width: bv_W - (bv_M + bv_M/2 + bv_Lw)*2 , height: bv_Sh)
        self.preBtn.frame = CGRect.init(x: 0, y: bv_Sh, width: bv_W/3, height: bv_H - bv_Sh)
        self.playBtn.frame = CGRect.init(x: bv_W/3, y: bv_Sh, width: bv_W/3, height: bv_H - bv_Sh)
        self.nextBtn.frame = CGRect.init(x: bv_W/3*2, y: bv_Sh, width: bv_W/3, height: bv_H - bv_Sh)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
