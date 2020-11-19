//
//  PostTableViewCell.swift
//  CommentsManager
//
//  Created by Shing Yien on 18/11/2020.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var lblUser: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblBody: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        // Configure the view for the selected state
    }
    
    func commonInit(post: Post) {
        lblUser.text = "User \(post.userId)"
        lblTitle.text = post.title
        lblBody.text = post.body
    }
}
