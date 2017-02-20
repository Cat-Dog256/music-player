//
//  ListCell.swift
//  MusicPlayer
//
//  Created by MoGo on 17/2/14.
//  Copyright © 2017年 李策--MoGo--. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell {
    var model : MusicModel? = MusicModel.init(){
        didSet{
           self.imageView?.image = UIImage.init(named: (model?.icon)!)
            self.textLabel?.text = model?.name
            self.detailTextLabel?.text = model?.singer
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.clear
        self.imageView?.layer.cornerRadius = 30
        self.imageView?.layer.masksToBounds = true
        self.textLabel?.font = UIFont.systemFont(ofSize: 14)
        self.detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
