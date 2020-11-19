//
//  CommentListPresenter.swift
//  CommentsManager
//
//  Created by Shing Yien on 18/11/2020.
//

import Foundation

protocol CommentListDelegate: class {
    func showLoading()
    func hideLoading()
    func fetchDataSucceed(data: [Comment])
    func fetchDataFailed(message: String)
    func updateComments(filteredComments: [Comment])
}

class CommentListPresenter{
    weak var delegate: CommentListDelegate?
    var allComments: [Comment] = []
    var apiService: APIService?
    
    init(delegate: CommentListDelegate, apiService: APIService) {
        self.delegate = delegate
        self.apiService = apiService
    }
    
    func fetchPostComments(postId: Int) {
        self.delegate?.showLoading()

        apiService?.fetchPostComments(postId: postId) { [weak self] (success, comments) in
            
            guard let self = self else {
                return
            }
            
            self.delegate?.hideLoading()
            
            if success, let data = comments {
                self.allComments = data
                self.delegate?.fetchDataSucceed(data: self.allComments)
            } else {
                self.delegate?.fetchDataFailed(message: "")
            }
        }
    }
    
    func filterComments(searchText: String) {
        // Filter comments by name, email and comment body
        if searchText.isEmpty {
            self.delegate?.updateComments(filteredComments: allComments)
        } else {
            let searchTextLowercased = searchText.lowercased()
            let filteredComments = allComments.filter({
                $0.name.lowercased().contains(searchTextLowercased) ||
                $0.email.lowercased().contains(searchTextLowercased) ||
                $0.body.lowercased().contains(searchTextLowercased) })
            self.delegate?.updateComments(filteredComments: filteredComments)
        }
    }
}

