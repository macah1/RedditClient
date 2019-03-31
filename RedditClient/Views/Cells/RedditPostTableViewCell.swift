//
//  RedditPostTableViewCell.swift
//  RedditClient
//
//  Created by Maca on 31/03/2019.
//  Copyright © 2019 Pablo Bernardi. All rights reserved.
//

import UIKit

class RedditPostTableViewCell: UITableViewCell {

    // MARK: - Static
    static let identifier = "redditPostCell"
    static let name = "RedditPostTableViewCell"
    
    // MARK: - Outlets
    @IBOutlet weak var readDotLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var postDateLabel: UILabel!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dismissPostButton: UIButton!
    @IBOutlet weak var commentsLabel: UILabel!
    
    // MARK: - Funcs
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Actions
    @IBAction func dismissPostButtonAction(_ sender: Any) {
    }
    
    
}
