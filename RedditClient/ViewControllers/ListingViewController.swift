//
//  ListingViewController.swift
//  RedditClient
//
//  Created by Maca on 31/03/2019.
//  Copyright © 2019 Pablo Bernardi. All rights reserved.
//

import UIKit

class ListingViewController: UITableViewController {

    // Mark: - Properties
    let kShowDetailSegueIdentifier = "showDetail"
    var detailViewController: DetailViewController? = nil

    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        registerTableViewCells()
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == kShowDetailSegueIdentifier {
            if let indexPath = tableView.indexPathForSelectedRow {

                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController

                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: RedditPostTableViewCell.identifier, for: indexPath) as? RedditPostTableViewCell {
            cell.titleLabel.text = "Sample Text"
            return cell
        }
        return UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: kShowDetailSegueIdentifier, sender: nil)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Private
    fileprivate func registerTableViewCells() {
        let redditPostCell = UINib(nibName: RedditPostTableViewCell.name, bundle: nil)
        self.tableView.register(redditPostCell, forCellReuseIdentifier: RedditPostTableViewCell.identifier)
    }

}

