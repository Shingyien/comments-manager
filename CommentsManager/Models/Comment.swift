//
//  Comment.swift
//  CommentsManager
//
//  Created by Shing Yien on 18/11/2020.
//

import Foundation

struct Comment: Codable, Equatable {
    var postId: Int
    var id: Int
    var name : String
    var email: String
    var body: String
    
    static func == (lhs: Comment, rhs: Comment) -> Bool {
        return lhs.postId == rhs.postId && lhs.id == rhs.id && lhs.name == rhs.name && lhs.email == rhs.email && lhs.body == rhs.body
    }
}
