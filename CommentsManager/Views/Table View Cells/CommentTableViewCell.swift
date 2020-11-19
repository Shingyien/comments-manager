//
//  CommentTableViewCell.swift
//  CommentsManager
//
//  Created by Shing Yien on 18/11/2020.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblBody: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        // Configure the view for the selected state
    }
    
    func commonInit(comment: Comment) {
        lblName.text = comment.name
        lblEmail.text = comment.email
        lblBody.text = comment.body
    }
    
}
