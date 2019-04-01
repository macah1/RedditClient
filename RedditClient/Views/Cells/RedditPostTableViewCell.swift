//
//  RedditPostTableViewCell.swift
//  RedditClient
//
//  Created by Maca on 31/03/2019.
//  Copyright © 2019 Pablo Bernardi. All rights reserved.
//

import UIKit

protocol RedditPostTableViewCellDelegate: class {
    func didTapDismiss(_ cell: RedditPostTableViewCell)
}

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
    
    // MARK: - Properties
    weak var delegate: RedditPostTableViewCellDelegate?
    
    // MARK: - Funcs
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Public
    func setup(withPost post: Post) {
        authorLabel.text = post.author ?? ""
        postDateLabel.text = post.created?.timeAgoSinceDate(numericDates: true) ?? ""
        titleLabel.text = post.title ?? ""
        if let numComments = post.numComments {
            if numComments == 1 {
                commentsLabel.text = "\(numComments) comment"
            } else {
                commentsLabel.text = "\(numComments) comments"
            }
        } else {
            commentsLabel.text = ""
        }
        if let thumbnailURLString = post.thumbnail {
            thumbImageView.cacheImage(urlString: thumbnailURLString)
        } else {
            thumbImageView.image = nil
        }
    }
    
    // MARK: - Actions
    @IBAction func dismissPostButtonAction(_ sender: Any) {
        delegate?.didTapDismiss(self)
    }
    
    
}
