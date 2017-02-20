//
//  PlayerViewController.swift
//  MusicPlayer
//
//  Created by MoGo on 17/2/13.
//  Copyright © 2017年 李策--MoGo--. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController {
  
   
    public var bgImageView: UIImageView!
    
    public var musicModel : MusicModel!
    
    /// 刷新歌词进度的计时器
    private var timer : Timer?
    
    /// 刷新歌词滚动的计时器
    private var displayLink : CADisplayLink?
    
    /// 记录滚动歌词的上一行，刷新为原来的颜色
    fileprivate var lastRowIndex = -1
    fileprivate var lrcDataSource  : [MusicLrcModel]?
    
    fileprivate var tapGesture : UITapGestureRecognizer!
    fileprivate var bottomView : BottomView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addNotificationCenter()
        self.setUpbgImageView()
        self.setUpLrcTabelView()
        self.setUpBottomView()
        self.setUpDataOnce()
        self.addTapGesture()
        // Do any additional setup after loading the view.
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    override func viewWillAppear(_ animated: Bool) {
        
        
        self.addTimer()
        
        self.addDisplayLink()
        
        UIApplication.shared.beginReceivingRemoteControlEvents()

    }
    override var canBecomeFirstResponder: Bool{
        return true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.removeTimer()
        self.removeDisplayLink()
        UIApplication.shared.endReceivingRemoteControlEvents()

    }
    deinit{
        self.removeNotificationCenter()
        
        print("销毁")
    }
    func setUpbgImageView() -> Void {
        self.bgImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 64, width: kMinScreenW, height: kMinScreenH - 64))
        self.bgImageView.isUserInteractionEnabled = true
        self.view.addSubview(self.bgImageView)
        //首先创建一个模糊效果
        let blurEffect = UIBlurEffect(style: .dark)
        //接着创建一个承载模糊效果的视图
        let blurView = UIVisualEffectView(effect: blurEffect)
        //设置模糊视图的大小
        blurView.frame.size = CGSize(width: kMinScreenW, height: kMinScreenH - 64)
        self.bgImageView.addSubview(blurView)

    }
    lazy var lrcTabelView : UITableView = {
        var tableV = UITableView.init(frame: CGRect.init(x: 0, y: 64, width: kMinScreenW, height: kConentViewH ) , style: UITableViewStyle.grouped)
        
        tableV.delegate = self
        tableV.dataSource = self
        tableV.allowsSelection = false

        return tableV
    }()
    lazy var contentView : LrcContentView = {
        let cV = LrcContentView.loadLrcContentView()
        cV.frame = CGRect.init(x: 0, y: 64, width: kMinScreenW, height: kConentViewH )
        self.view.addSubview(cV)
        return cV
    }()
    func setUpLrcTabelView() -> Void {
        let insetH = kConentViewH/2
        self.lrcTabelView.backgroundColor = UIColor.clear
        self.lrcTabelView.isHidden = true
        self.lrcTabelView.separatorStyle = .none
        self.lrcTabelView.contentInset = UIEdgeInsets.init(top:insetH , left: 0, bottom: insetH, right: 0)
        self.view.addSubview(self.lrcTabelView)
    }
    
    // MARK: 刷新歌词
    func setUpDataOnce() -> Void {
        let message = MusicOperationTool.shareInstance().getNewMusicMeeageModel()
        
        self.navigationItem.title =  message.musicM.name
        
        self.bottomView.curTimeL.text = message.costTimeFormat
        self.bottomView.tolTimeL.text = message.totalTimeFormat
        self.bottomView.progressSlider.value = Float.init(message.costTime/message.totalTime)
        
        
        let lrcModes = LrcDataTool.getLrcData(fileName: message.musicM.lrcname!, totalTime: message.totalTime)
        self.contentView.musicModel = message.musicM
        self.lrcDataSource = lrcModes
        self.lrcTabelView.reloadData()
        
        self.bgImageView.image = UIImage.init(named: message.musicM.icon!)
        if message.playing == true{
            self.contentView.resumeRotationAnimatioin()
        }else{
            
        }
    }
    
    // MARK:刷新播放进度的文字
    @objc func setUpDataTimes() -> Void {
        let message = MusicOperationTool.shareInstance().getNewMusicMeeageModel()
        let proess = 1.0 * message.costTime / message.totalTime
        self.bottomView.progressSlider.value = Float.init(proess)
        
        self.bottomView.curTimeL.text = message.costTimeFormat
        self.bottomView.playBtn.isSelected = message.playing
        
    }
    
    /// MARK：一首歌曲播放结束的通知 genxin
    func onceMuiscDidFinished() {
        MusicOperationTool.shareInstance().nextMusic()
        self.bottomView.progressSlider.value = 0
        self.bottomView.curTimeL.text = "00:00"
        //更新歌曲
        self.setUpDataOnce()
    }
    func addNotificationCenter() -> Void {
           NotificationCenter.default.addObserver(self, selector: #selector(onceMuiscDidFinished), name: NSNotification.Name(rawValue: kPlayFinishNotificationName), object: nil)
    }
    func removeNotificationCenter() -> Void {
        NotificationCenter.default.removeObserver(self)
    }
    func addTimer() -> Void {
        if self.timer == nil {
            self.timer = Timer.init(timeInterval: 1.0, target: self, selector: #selector(setUpDataTimes), userInfo: nil, repeats: true)
            RunLoop.current.add(self.timer!, forMode: RunLoopMode.commonModes)
        }
    }
    func removeTimer() -> Void {
        self.timer?.invalidate()
        self.timer = nil
    }
    func addDisplayLink(){
        self.displayLink = CADisplayLink.init(target: self, selector: #selector(updateLrc))
        self.displayLink?.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
    }
    func removeDisplayLink() -> Void {
        self.displayLink?.invalidate()
        self.displayLink = nil
    }
    
    // MARK: 刷新歌词
    func updateLrc() -> Void {
        let message = MusicOperationTool.shareInstance().getNewMusicMeeageModel()
        LrcDataTool.getRowLrc(currentTime: message.costTime, lrcMs: self.lrcDataSource!) { (index, lrcModel) in
            self.scrollLrcTabel(row: index ,lrcM: lrcModel )
        }
        let status = UIApplication.shared.applicationState
        if  status == UIApplicationState.background {
        }
        // MARK：锁屏界面设置
        MusicOperationTool.shareInstance().setUpLockMessage()
    }
    
    // MARK:滚动歌词
    ///
    /// - parameter row:  行
    /// - parameter lrcM: MusicLrcModel
    func scrollLrcTabel(row:NSInteger , lrcM : MusicLrcModel) -> Void {
        let indexPath = IndexPath.init(row: row, section: 0)
        //进入下一行，滚动到中间，把上一行刷新为原来的颜色
        if self.lastRowIndex != row {
            self.lrcTabelView.scrollToRow(at: indexPath, at: .middle, animated: true)

            if lastRowIndex >= 0 && lastRowIndex <= (self.lrcDataSource?.count)! - 1 {
                 let lastCell = self.lrcTabelView.cellForRow(at: IndexPath.init(row: self.lastRowIndex, section: 0)) as? LrcCell
                lastCell?.contentLabel.resetDisplayColor()
            }
           self.contentView.setLrcString(lrcStr: lrcM.lrcStr)
            self.lastRowIndex = row
        }
        //刷新单行歌词的进度
        let message = MusicOperationTool.shareInstance().getNewMusicMeeageModel()
        let progress = (message.costTime - lrcM.beginTime)/(lrcM.endTIme - lrcM.beginTime)
        let cell = self.lrcTabelView.cellForRow(at: indexPath) as? LrcCell
        cell?.progress = CGFloat.init(progress)
        self.contentView.MyLrcLabel.progress = CGFloat.init(progress)

    }
    @objc func tapAction() -> Void {
        if self.contentView.isHidden == true {
            self.contentView.isHidden = false
            self.lrcTabelView.isHidden = true
        }else{
            self.contentView.isHidden = true
            self.lrcTabelView.isHidden = false
        }
    }
    func addTapGesture() -> Void {
         self.tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapAction))
        self.lrcTabelView.addGestureRecognizer(self.tapGesture)
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction))
        self.contentView.addGestureRecognizer(tap)
    }
    func removeTapGesture() -> Void {
        self.lrcTabelView.removeGestureRecognizer(self.tapGesture)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension PlayerViewController {
    func setUpBottomView() -> Void {
        let bottomV = BottomView.init(frame:CGRect.init(x: 0, y: self.view.frame.size.height - 110, width: self.view.frame.size.width, height: 100) )
        bottomV.progressSlider.addTarget(self, action: #selector(sliderValueChanged(slider:)), for: UIControlEvents.valueChanged)
        bottomV.progressSlider.addTarget(self, action: #selector(sliderTouchUp(slider:)), for: UIControlEvents.touchUpInside)
        bottomV.progressSlider.addTarget(self, action: #selector(sliderTouchDown(slider:)), for: UIControlEvents.touchDown)
        self.view.addSubview(bottomV)
        self.bottomView = bottomV
        // MARK: 这里必须用weakSelf弱化引用
        // self 持有 bottomView 在调用 self 的方法 ，会形成循环引用 ，析构函数deinit不会调用
        weak var weakSelf = self
        //MARK:上一曲
        self.bottomView.preEvent { (preBtn) in
            weakSelf?.preMusic()
        }
       
        //MARK:⏸ ▶️
        self.bottomView.playEvent { (playBtn) in
            if(playBtn.isSelected){
                MusicOperationTool.shareInstance().playCurrentMusic()
                weakSelf?.contentView.resumeRotationAnimatioin()
            }else{
                MusicOperationTool.shareInstance().pauseCurrentMusic()
                weakSelf?.contentView.pauseRotationAnimation()
            }
        }
        //MARK:下一曲
        self.bottomView.nextEvent { (nextBtn) in
            weakSelf?.nextMusic()
        }
    }
    func preMusic() -> Void {
        MusicOperationTool.shareInstance().preMusic()
        self.bottomView.progressSlider.value = 0
        self.bottomView.curTimeL.text = "00:00"
        self.setUpDataOnce()
    }

    func nextMusic() -> Void {
        MusicOperationTool.shareInstance().nextMusic()
        
        self.bottomView.progressSlider.value = 0
        self.bottomView.curTimeL.text = "00:00"
        self.setUpDataOnce()
    }
    func sliderTouchDown(slider:UISlider)->Void{
        self.removeTimer()
    }
    func sliderTouchUp(slider:UISlider)->Void{
        
        self.addTimer()
        let message = MusicOperationTool.shareInstance().getNewMusicMeeageModel()
        let currentTime : TimeInterval = Double.init(slider.value) * message.totalTime
        MusicOperationTool.shareInstance().seekTo(currentTime: currentTime)
    }
    func sliderValueChanged(slider:UISlider)->Void{
                let message = MusicOperationTool.shareInstance().getNewMusicMeeageModel()
        message.costTime = Double.init(slider.value) * message.totalTime
        self.bottomView.curTimeL.text = message.costTimeFormat
    }
}

extension PlayerViewController : UITableViewDelegate ,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.lrcDataSource!.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = LrcCell.loadLrcCell(onTabeView: tableView)
        cell.setLrcString(lrcStr: (self.lrcDataSource?[indexPath.row].lrcStr)!)
        //刷新为原来的颜色，复用
        cell.contentLabel.resetDisplayColor()
        
        return cell;
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
}
/*
 // available in iPhone OS 3.0
 case none
 
 
 // for UIEventTypeMotion, available in iPhone OS 3.0
 case motionShake
 
 
 // for UIEventTypeRemoteControl, available in iOS 4.0
 case remoteControlPlay
 
 case remoteControlPause
 
 case remoteControlStop
 
 case remoteControlTogglePlayPause
 
 case remoteControlNextTrack
 
 case remoteControlPreviousTrack
 
 case remoteControlBeginSeekingBackward
 
 case remoteControlEndSeekingBackward
 
 case remoteControlBeginSeekingForward
 
 case remoteControlEndSeekingForward
 */
/*
 1.第一步：UIApplication.shared.beginReceivingRemoteControlEvents()
 2.第二步：info.plist 中添加Required background modes Array item0 输入auido回车
 3.第三步：remoteControlReceived
 */
// MARK:remoteControlReceived 远程桌面控制
extension PlayerViewController{
    
    override func remoteControlReceived(with event: UIEvent?) {
        
        let eventType : UIEventSubtype = (event?.subtype)!
        switch eventType {
        case .remoteControlPlay:
            MusicOperationTool.shareInstance().playCurrentMusic()
            self.contentView.resumeRotationAnimatioin()
            print("%@ -- %@",#function , #line)
            break
        case .remoteControlPause:
            MusicOperationTool.shareInstance().pauseCurrentMusic()
            self.contentView.pauseRotationAnimation()
             print("%@ -- %@",#function , #line)
            break
        case .remoteControlStop:
             print("%@ -- %@",#function , #line)
            break
        case .remoteControlTogglePlayPause:
             print("%@ -- %@",#function , #line)
            break
        case .remoteControlPreviousTrack:
            self.preMusic()
             print("%@ -- %@",#function , #line)
            break
        case .remoteControlNextTrack:
            self.nextMusic()
             print("%@ -- %@",#function , #line)
            break
        case .remoteControlBeginSeekingBackward:
             print("%@ -- %@",#function , #line)
            break
        case .remoteControlEndSeekingBackward:
             print("%@ -- %@",#function , #line)
            break
        case .remoteControlBeginSeekingForward:
             print("%@ -- %@",#function , #line)
            break
        case .remoteControlEndSeekingForward:
             print("%@ -- %@",#function , #line)
            break
        default:
            break
        }
        
    }
}
