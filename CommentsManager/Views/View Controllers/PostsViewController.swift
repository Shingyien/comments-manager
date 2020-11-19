//
//  PostsViewController.swift
//  CommentsManager
//
//  Created by Shing Yien on 18/11/2020.
//

import UIKit

class PostsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var postTableView: UITableView!
    
    var presenter: PostListPresenter?
    
    var posts: [Post] = []
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell xib
        postTableView.register( UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: "PostTableViewCell")
        
        // Set dynamic height for cell
        postTableView.rowHeight = UITableView.automaticDimension
        postTableView.estimatedRowHeight = 200.0
        
        // Set presenter
        presenter = PostListPresenter(delegate: self)
        presenter?.fetchPostList()
        
        // Add target for refresh control
        refreshControl.addTarget(self, action: #selector(self.refreshArticlesData(_:)), for: .valueChanged)
    }
    
    // MARK: - Table View delegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = postTableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as! PostTableViewCell
        
        let post = posts[indexPath.row]
        
        cell.commonInit(post: post)

        return cell
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "CommentsViewController") as! CommentsViewController
        vc.post = posts[indexPath.row]
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Extensions

extension PostsViewController: postListDelegate {
    func showLoading() {
        postTableView.refreshControl = self.refreshControl
        postTableView.refreshControl?.beginRefreshing()
    }
    
    func hideLoading() {
        postTableView.refreshControl?.endRefreshing()
    }
    
    func fetchDataSucceed(data: [Post]) {
        posts = data
        postTableView.reloadData()
    }
    
    func fetchDataFailed(message: String) {
        let alert = UIAlertController(title: "Error", message: "Failed to fetch posts. Please try again later.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
    
    @objc private func refreshArticlesData(_ sender: Any) {
        presenter?.fetchPostList()
    }
}

