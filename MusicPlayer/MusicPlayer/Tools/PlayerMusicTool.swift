//
//  PlayerMusicTool.swift
//  MusicPlayer
//
//  Created by MoGo on 17/2/14.
//  Copyright © 2017年 李策--MoGo--. All rights reserved.
//

import UIKit
import AVFoundation
enum PlayerError : Error {
    case UrlError
    case InitPlayerError
}
class PlayerMusicTool: NSObject {
    public var player : AVAudioPlayer?
    func playingMusic(fileName:String?) throws {
        
        let musicUrl = Bundle.main.url(forResource: fileName, withExtension: nil)
        if musicUrl == nil {
            throw PlayerError.UrlError
        }
        if self.player != nil {
            if self.player!.url != nil {
                let lastUrl = self.player!.url! as NSURL
                let curUrl = musicUrl! as NSURL
                if (lastUrl.isEqual(curUrl)) {
                    self.player!.play()
                    return;
                }
            }
        }
        
        
        //1.创建播放器
        do {
            self.player = try AVAudioPlayer.init(contentsOf: musicUrl!, fileTypeHint: nil)
            
            self.player?.delegate = self
            //2.准备播放
            self.player?.prepareToPlay()
            //3.开始播放
            self.player?.play()
        } catch {
            throw PlayerError.InitPlayerError
        }
       
        
    }
    
    /// 暂停播放
    func pauseCurrentMusic(){
        self.player?.pause()
    }
    
    /// 继续播放
    func resumeCurrentMusic(){
        self.player?.play()
    }
    
    /// 播放进度
    ///
    /// - parameter timeInteval: 指定播放时间
    func seekTo(timeInteval : TimeInterval){
        self.player?.currentTime = timeInteval
    }
}

// MARK: - AVAudioPlayerDelegate
extension PlayerMusicTool : AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kPlayFinishNotificationName), object: nil)
    }
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        
    }
}
