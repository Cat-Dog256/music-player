//
//  MusicOperationTool.swift
//  MusicPlayer
//
//  Created by MoGo on 17/2/14.
//  Copyright © 2017年 李策--MoGo--. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
final class MusicOperationTool: NSObject {
    var lrcRow = -1
    var artWork : MPMediaItemArtwork?
    private static let shared = MusicOperationTool()
    public var musicList : [MusicModel]!
    public var index = 0{
        didSet{
            if index <= 0 {
                index = 0
            }
            if index >= self.musicList.count - 1 {
                index = self.musicList.count - 1
            }
        }
    }
    public let musicMessage : MusicMessageModel = MusicMessageModel()
    public let playerTool = PlayerMusicTool.init()
    public static func shareInstance() ->MusicOperationTool{
        return shared
    }
    override init(){
        super.init()
        do {
            // MARK:AVAudioSessionCategorySoloAmbient 停止其他音乐
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategorySoloAmbient)
            // MARK:AVAudioSessionCategoryPlayback 支持后台播放
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try  AVAudioSession.sharedInstance().setActive(true)

        } catch {
            print("%@ -- %@",#function , #line)
        }
        
    }
    func getNewMusicMeeageModel() -> MusicMessageModel {
        self.musicMessage.musicM = self.musicList[self.index]
        
        self.musicMessage.costTime = self.playerTool.player?.currentTime
        
        self.musicMessage.totalTime = self.playerTool.player?.duration
        
        self.musicMessage.playing = (self.playerTool.player?.isPlaying)!
        
        return self.musicMessage
    }

    /// 开始播放
    ///
    /// - parameter music: 歌曲对象模型
    func playMusic(music:MusicModel) -> Void {
        do {
            if self.musicList.contains(music) {
                self.index = self.musicList.index(of: music)!
            }else{
                print("音乐列表中不存在该文件")
                return
            }

            try self.playerTool.playingMusic(fileName: music.filename)
            
        } catch {
            
        }
        
    }
    
    /// 播放
    func playCurrentMusic() -> Void {
        self.playerTool.resumeCurrentMusic()
    }
    
    /// 暂停
    func pauseCurrentMusic() -> Void {
        self.playerTool.pauseCurrentMusic()
    }
    
    /// 下一曲
    func nextMusic() -> Void {
        self.index += 1
        let music = self.musicList[self.index]
        self.playMusic(music: music)
    }
    
    /// 上一曲
    func preMusic() -> Void {
        self.index -= 1
        let music = self.musicList[self.index]
        self.playMusic(music: music)

    }
    func seekTo(currentTime:TimeInterval) -> Void {
        self.playerTool.seekTo(timeInteval: currentTime)
    }
    
    /// 设置锁屏信息
    func setUpLockMessage() -> Void {
        let messageModel = self.getNewMusicMeeageModel()
        let lrcModels = LrcDataTool.getLrcData(fileName: messageModel.musicM.lrcname!, totalTime: messageModel.totalTime)
        var lrcM : MusicLrcModel?
        var currentRow = -1
        
        LrcDataTool.getRowLrc(currentTime: messageModel.costTime, lrcMs:lrcModels) { (index, lrcModel) in
            lrcM = lrcModel
            currentRow = index
        }
        let songName = messageModel.musicM.name
        let singerName = messageModel.musicM.singer
        let costTime = messageModel.costTime
        let totalTime = messageModel.totalTime
        let icon = messageModel.musicM.icon
        
        // 1.2 创建字典
        var playingMusicInfoDic = [
            // 歌曲名称
            MPMediaItemPropertyAlbumTitle : songName ?? "未知歌曲",
            
            // 演唱者
            MPMediaItemPropertyArtist : singerName ?? "未知歌手",
            
            // 当前播放的时间
            MPNowPlayingInfoPropertyElapsedPlaybackTime : NSNumber.init(value: costTime!),
            
            // 总时长
            MPMediaItemPropertyPlaybackDuration : NSNumber.init(value: totalTime!),
        ] as [String : Any];
        if self.lrcRow != currentRow {
            if icon != nil {
                let image = UIImage.init(named: icon!)
                let lrcImage = self.drawLrcImage(sourceImage: image!, lrcStr: lrcM?.lrcStr)
                
                if lrcImage != nil {
                    self.artWork = MPMediaItemArtwork.init(image: lrcImage!)
                }
            }

        }
        if self.artWork != nil {
             playingMusicInfoDic[MPMediaItemPropertyArtwork] = self.artWork
        }
        MPNowPlayingInfoCenter.default().nowPlayingInfo = playingMusicInfoDic
        
    }
    func drawLrcImage(sourceImage:UIImage , lrcStr : String?) -> UIImage? {
        let size : CGSize = sourceImage.size
        // 1.开启图形上下文
        UIGraphicsBeginImageContext(size)
        // 2.绘制大的图片
        sourceImage.draw(in: CGRect.init(origin: CGPoint.init(), size: size))
        
        // 3.绘制歌词
        let style : NSMutableParagraphStyle = NSMutableParagraphStyle.init()
        style.alignment = NSTextAlignment.center
        
        let attris : [String : AnyObject] = [
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName : UIFont.systemFont(ofSize: 18),
            NSParagraphStyleAttributeName : style,
        ]
        if lrcStr != nil {
            (lrcStr! as NSString).draw(in: CGRect.init(x: 0, y: size.height - 30, width: size.width, height: 26), withAttributes: attris)
        }
        
        // 4.获取结果图片
         let resultImage = UIGraphicsGetImageFromCurrentImageContext();
        
        // 5.关闭图形上下文
        UIGraphicsEndImageContext();
        
        return resultImage
    }
}
