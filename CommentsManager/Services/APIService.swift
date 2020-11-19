//
//  APIService.swift
//  CommentsManager
//
//  Created by Shing Yien on 18/11/2020.
//

import Alamofire

class APIService {
    
    // MARK: - Properties
    static let shared = APIService()
    var apiBaseURL: String?
    
    init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        apiBaseURL = appDelegate.infoForKey("API_BASE_URL")
    }
    
    /**
     Fetch all posts
     */
    func fetchPostList(callback: @escaping (Bool, [Post]?) -> Void) {
        
        let url = URL(string: apiBaseURL!)!.appendingPathComponent("/posts")
        
        AF.request(url)
            .validate(statusCode: 200..<300)
            .responseDecodable { (response: DataResponse<[Post], AFError>) in
                switch response.result {
                case .success (let postListData):
                    callback(true, postListData)
                case .failure (let error):
                    print("\(error.localizedDescription)")
                    callback(false, [])
                }
        }
    }
    
    /**
     Fetch all comments related to a post
     */
    func fetchPostComments(postId: Int, callback: @escaping (Bool, [Comment]?) -> Void) {
        
        let url = URL(string: apiBaseURL!)!.appendingPathComponent("/comments")

        let parameters = [
            "postId" : postId
        ]
        
        AF.request(url, parameters: parameters, encoding: URLEncoding(destination: .queryString))
                .validate(statusCode: 200..<300)
                .responseDecodable { (response: DataResponse<[Comment], AFError>) in
                    switch response.result {
                    case .success (let commentData):
                        callback(true, commentData)
                    case .failure (let error):
                        print("\(error.localizedDescription)")
                        callback(false, [])
                    }
            }
   }
}
