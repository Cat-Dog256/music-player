//
//  LrcContentView.swift
//  MusicPlayer
//
//  Created by MoGo on 17/2/17.
//  Copyright © 2017年 李策--MoGo--. All rights reserved.
//

import UIKit

class LrcContentView: UIView {
    @IBOutlet weak var MyLrcLabel: LrcLabel!
    @IBOutlet weak var bgView: UIView!
    var FeImageView: UIImageView!
    public var musicModel : MusicModel = MusicModel.init() {
        didSet{
            self.FeImageView.image = UIImage.init(named: musicModel.icon!)
        }
    }
    static func loadLrcContentView() -> LrcContentView {
        return Bundle.main.loadNibNamed("LrcContentView", owner: self, options: nil)?.first as! LrcContentView
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.FeImageView = UIImageView.init()
        self.bgView.addSubview(self.FeImageView)
        self.addRotationAnimation()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.FeImageView.bounds = CGRect.init(x: 0, y: 0, width: kMinScreenW - 80, height: kMinScreenW - 80)
        self.FeImageView.center = self.bgView.center
        self.FeImageView.layer.borderWidth = 1
        self.FeImageView.layer.borderColor = UIColor.white.cgColor
        self.FeImageView.layer.cornerRadius = (kMinScreenW - 80)/2
        self.FeImageView.layer.masksToBounds = true
    }
    func setLrcString(lrcStr:String) -> Void {
        self.MyLrcLabel.text = lrcStr
        self.MyLrcLabel.sizeToFit()
        self.MyLrcLabel.center = CGPoint.init(x: self.frame.size.width/2, y: self.frame.size.height - 40)
    }
    // MARK:旋转动画
    func addRotationAnimation() -> Void {
        let key = "rotation"
        self.FeImageView.layer.removeAnimation(forKey: key)
        let animation = CABasicAnimation.init(keyPath: "transform.rotation.z")
        animation.isRemovedOnCompletion = false
        animation.fromValue = 0.0
        animation.toValue = M_PI * 2
        animation.duration = 30
        animation.repeatCount = MAXFLOAT
        self.FeImageView.layer.add(animation, forKey: key)
    }
    // MARK:暂停旋转动画
    func pauseRotationAnimation() -> Void {
        let pausedTime : CFTimeInterval = self.FeImageView.layer.convertTime(CACurrentMediaTime(), from: nil)
        self.FeImageView.layer.speed = 0
        self.FeImageView.layer.timeOffset = pausedTime
    }
    // MARK:回复旋转动画
    func resumeRotationAnimatioin() -> Void {
        let pausedTime : CFTimeInterval = self.FeImageView.layer.timeOffset
        self.FeImageView.layer.speed = 1.0
        self.FeImageView.layer.beginTime = 0.0
        let timeSincePause = self.FeImageView.layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        
        self.FeImageView.layer.beginTime = timeSincePause

    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
//        //首先创建一个模糊效果
//        let blurEffect = UIBlurEffect(style: .light)
//        //接着创建一个承载模糊效果的视图
//        let blurView = UIVisualEffectView(effect: blurEffect)
//        //设置模糊视图的大小
//        blurView.frame.size = CGSize(width: kMinScreenW, height: kConentViewH)

//        //创建并添加vibrancy视图
//        let vibrancyView = UIVisualEffectView.init(effect:  UIVibrancyEffect.init(blurEffect: blurEffect))
//        vibrancyView.frame.size = CGSize(width: self.frame.width, height: self.frame.height)
//        blurView.contentView.addSubview(vibrancyView)

//        //将文本标签添加到vibrancy视图中
//        let label = UILabel(frame:CGRect.init(x: 10, y: 20, width: 300, height: 100))
//        label.text = "hangge.com"
//        label.font = UIFont(name: "HelveticaNeue-Bold", size: 40)
//        label.textAlignment = .center
//        label.textColor = UIColor.white
//        vibrancyView.contentView.addSubview(label)

// self.BgImageView.addSubview(blurView)
