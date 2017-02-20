//
//  LrcCell.swift
//  MusicPlayer
//
//  Created by MoGo on 17/2/16.
//  Copyright © 2017年 李策--MoGo--. All rights reserved.
//

import UIKit

class LrcCell: UITableViewCell {
    static let reuseId = "lrc_cell"
    
    public var progress : CGFloat = 0{
        didSet{
           self.contentLabel.progress = progress
        }
    }
    public var contentLabel = LrcLabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
        self.contentLabel.backgroundColor = UIColor.clear
        self.contentLabel.font = UIFont.systemFont(ofSize: 14)
        self.contentView.addSubview(contentLabel)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentLabel.sizeToFit()
        self.contentLabel.center = self.contentView.center
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    static func loadLrcCell(onTabeView:UITableView) -> LrcCell{
        var lrcCell = onTabeView.dequeueReusableCell(withIdentifier: reuseId)
        if lrcCell == nil {
            lrcCell = LrcCell.init(style: UITableViewCellStyle.default, reuseIdentifier: reuseId)
        }
           return lrcCell as! LrcCell
        }
    func setLrcString(lrcStr:String) -> Void {
        self.contentLabel.text = lrcStr
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
