//
//  postListPresenter.swift
//  CommentsManager
//
//  Created by Shing Yien on 18/11/2020.
//

import Foundation

protocol postListDelegate: class {
    func showLoading()
    func hideLoading()
    func fetchDataSucceed(data: [Post])
    func fetchDataFailed(message: String)
}

class PostListPresenter{
    weak var delegate: postListDelegate?
    
    init(delegate: postListDelegate) {
        self.delegate = delegate
    }
    
    func fetchPostList() {
        self.delegate?.showLoading()

        APIService().fetchPostList() { [weak self] (success, postList) in
                        
            guard let self = self else {
                return
            }
            
            self.delegate?.hideLoading()
            
            if success, let data = postList {
                self.delegate?.fetchDataSucceed(data: data)
            } else {
                self.delegate?.fetchDataFailed(message: "")
            }
        }
    }
}
