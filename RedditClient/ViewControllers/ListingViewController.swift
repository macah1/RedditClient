//
//  ListingViewController.swift
//  RedditClient
//
//  Created by Maca on 31/03/2019.
//  Copyright © 2019 Pablo Bernardi. All rights reserved.
//

import UIKit

class ListingViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    let kShowDetailSegueIdentifier = "showDetail"
    var detailViewController: DetailViewController? = nil
    var viewModel: ListingViewModel!
    fileprivate var refreshControl: UIRefreshControl?

    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        registerTableViewCells()
        setupViewModel()
        prepareView()
        loadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectionIndexPath = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: selectionIndexPath, animated: animated)
        }
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
    
    // MARK: - Private
    fileprivate func prepareView() {
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: #selector(refreshControlAction(sender:)), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl!)
    }
    
    fileprivate func loadData() {
        viewModel?.loadData()
    }
    
    fileprivate func setupViewModel() {
        viewModel = ListingViewModel()
        viewModel?.delegate = self
    }
    
    fileprivate func registerTableViewCells() {
        let redditPostCell = UINib(nibName: RedditPostTableViewCell.name, bundle: nil)
        self.tableView.register(redditPostCell, forCellReuseIdentifier: RedditPostTableViewCell.identifier)
    }
    
    fileprivate func isLoadingIndexPath(_ indexPath: IndexPath) -> Bool {
        guard viewModel.hasMorePages else { return false }
        return indexPath.row == self.viewModel.posts.count
    }
    
    // MARK: - Actions
    @IBAction func dismissAllButtonAction(_ sender: Any) {
    }
    
    @objc func refreshControlAction(sender: AnyObject) {
        viewModel.resetNextId()
        loadData()
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ListingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if viewModel.posts.isEmpty {
            return 0
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = viewModel.posts.count
        return viewModel.hasMorePages ? count + 1 : count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: RedditPostTableViewCell.identifier, for: indexPath) as? RedditPostTableViewCell {
            
            if isLoadingIndexPath(indexPath) {
                let loadingCell = UITableViewCell()
                loadingCell.backgroundColor = UIColor.black
                return loadingCell
            }
            let post = viewModel.posts[indexPath.row]
            cell.setup(withPost: post)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: kShowDetailSegueIdentifier, sender: nil)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard isLoadingIndexPath(indexPath) else { return }
        loadData()
    }
}

extension ListingViewController: ListingViewModelDelegate {
    func didLoadedData() {
        self.tableView.reloadData()
    }
    
    func didEndLoadOperation() {
        self.refreshControl?.endRefreshing()
    }
    
    
}
