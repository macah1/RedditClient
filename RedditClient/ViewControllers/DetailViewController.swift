//
//  DetailViewController.swift
//  RedditClient
//
//  Created by Maca on 31/03/2019.
//  Copyright © 2019 Pablo Bernardi. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        prepareView()
    }

    func prepareView() {
        
    }
}

