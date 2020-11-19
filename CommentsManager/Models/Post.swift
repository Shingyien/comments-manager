//
//  Post.swift
//  CommentsManager
//
//  Created by Shing Yien on 18/11/2020.
//

import Foundation

struct Post: Codable {
    var userId: Int
    var id: Int
    var title: String
    var body: String
}
