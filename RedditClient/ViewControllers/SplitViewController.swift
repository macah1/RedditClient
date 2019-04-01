//
//  SplitViewController.swift
//  RedditClient
//
//  Created by Maca on 01/04/2019.
//  Copyright © 2019 Pablo Bernardi. All rights reserved.
//

import Foundation
import UIKit

class SplitViewController: UISplitViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    private func setup() {
        if self.traitCollection.userInterfaceIdiom == .pad {
            if UIApplication.shared.statusBarOrientation.isPortrait {
                self.preferredDisplayMode = .primaryOverlay
            } else {
                self.preferredDisplayMode = .allVisible
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if (self.traitCollection.userInterfaceIdiom == .pad) {
            let isPortrait = UIApplication.shared.statusBarOrientation.isPortrait
            
            if isPortrait {
                self.preferredDisplayMode = .primaryOverlay
            }
            else {
                self.preferredDisplayMode = .allVisible
            }
            
            coordinator.animate(alongsideTransition: { context in
            }) { context in
                if isPortrait {
                    self.preferredDisplayMode = .allVisible
                } else {
                    self.preferredDisplayMode = .primaryOverlay
                }
            }
        }
    }
}
