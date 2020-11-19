//
//  CommentsViewController.swift
//  CommentsManager
//
//  Created by Shing Yien on 18/11/2020.
//

import UIKit

class CommentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var post: Post?
    var comments: [Comment] = []
    var allComments: [Comment] = []
    
    var presenter: CommentListPresenter?
    let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var lblUser: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblBody: UILabel!
    @IBOutlet weak var commentsSearchBar: UISearchBar!
    @IBOutlet weak var commentsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell xib
        commentsTableView.register( UINib(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentTableViewCell")
        
        // Set dynamic height for cell
        commentsTableView.rowHeight = UITableView.automaticDimension
        commentsTableView.estimatedRowHeight = 200.0
        
        // Set presenter
        presenter = CommentListPresenter(delegate: self, apiService: APIService())
        presenter?.fetchPostComments(postId: post!.id)
        
        // Setup
        setupPost()
        commentsSearchBar.placeholder = "Search"
        
        // Tap anywhere beside textfields on screen to dismiss keyboard
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        // Add target for refresh control
        refreshControl.addTarget(self, action: #selector(self.refreshArticlesData(_:)), for: .valueChanged)
    }
    
    func setupPost() {
        lblUser.text = "User \(post!.userId)"
        lblTitle.text = post!.title
        lblBody.text = post!.body
    }
    
    // MARK: Searchbar delegate methods
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let text = searchBar.searchTextField.text {
            presenter?.filterComments(searchText: text)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    // MARK: Table view delegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = commentsTableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as! CommentTableViewCell
        
        let comment = comments[indexPath.row]
        
        cell.commonInit(comment: comment)

        return cell
    }
}

// MARK: - Extensions

extension CommentsViewController: CommentListDelegate {
    
    func showLoading() {
        commentsTableView.refreshControl = self.refreshControl
        commentsTableView.refreshControl?.beginRefreshing()
    }
    
    func hideLoading() {
        commentsTableView.refreshControl?.endRefreshing()
    }
    
    func fetchDataSucceed(data: [Comment]) {
        comments = data
        commentsTableView.reloadData()
    }
    
    func fetchDataFailed(message: String) {
        let alert = UIAlertController(title: "Error", message: "Failed to fetch posts. Please try again later.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
    
    func updateComments(filteredComments: [Comment]) {
        comments = filteredComments
        commentsTableView.reloadData()
    }
    
    @objc private func refreshArticlesData(_ sender: Any) {
        presenter?.fetchPostComments(postId: post?.id ?? 0)
    }
}
