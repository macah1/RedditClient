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
                
                if let postIndex = sender as? Int {
                    let detailViewModel = viewModel.getDetailViewModel(withPostIndex: postIndex)
                    controller.viewModel = detailViewModel
                }
            }
        }
    }
    
    // MARK: - Private
    fileprivate func prepareView() {
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: #selector(refreshControlAction(sender:)), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl!)
        
        // removing empty cells separators
        tableView.tableFooterView = UIView()
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
        if viewModel.posts.isEmpty {
            return
        }
        tableView.beginUpdates()
        let indexSet = NSMutableIndexSet()
        indexSet.add(0)
        tableView.deleteSections(indexSet as IndexSet, with: .top)
        viewModel.reset()
        tableView.endUpdates()
    }
    
    @objc func refreshControlAction(sender: AnyObject) {
        viewModel.setToRefresh()
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
                let myActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.white)
                myActivityIndicator.center = loadingCell.center
                myActivityIndicator.startAnimating()
                loadingCell.addSubview(myActivityIndicator)
                return loadingCell
            }
            let post = viewModel.posts[indexPath.row]
            cell.setup(withPost: post)
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? RedditPostTableViewCell {
            cell.setRead()
            viewModel.setPostStatus(at: indexPath.row, status: .read)
        }
        self.performSegue(withIdentifier: kShowDetailSegueIdentifier, sender: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard isLoadingIndexPath(indexPath) else { return }
        loadData()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 186
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

extension ListingViewController: RedditPostTableViewCellDelegate {
    func didTapDismiss(_ cell: RedditPostTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.left)
            viewModel.removePost(atIndex: indexPath.row)
            tableView.endUpdates()
        }
    }
}
