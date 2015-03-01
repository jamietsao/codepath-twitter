//
//  MenuUserCell.swift
//  Twitter
//
//  Created by Jamie Tsao on 2/27/15.
//  Copyright (c) 2015 jamietsao. All rights reserved.
//

import UIKit

class MenuUserCell: UITableViewCell {

    var user: User!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var username: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUser(user: User) {
        self.user = user
        
        // profile image
        if let url = self.user?.getProfileUrlOriginal() {
            self.profileImage.setImageWithURL(NSURL(string: url))
        }
        
        // name
        self.name.text = self.user?.name
        
        // username
        if let username = self.user?.username {
            self.username.text = "@" + username
        }
        
    }
    
}
