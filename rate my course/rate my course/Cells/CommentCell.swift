//
//  CommentCell.swift
//  rate my course
//
//  Created by chris on 3/29/19.
//  Copyright © 2019 com. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    @IBOutlet weak var commentLabel     :   UILabel!
    @IBOutlet weak var usernameLabel    :   UILabel!
    @IBOutlet weak var timeLabel        :   UILabel!
    @IBOutlet weak var dislikeLabel     :   UILabel!
    @IBOutlet weak var likeLabel        :   UILabel!
    @IBOutlet weak var likeButton       :   UIButton!
    @IBOutlet weak var dislikeButton    :   UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
