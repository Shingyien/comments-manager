//
//  CommentListPresenterTests.swift
//  CommentsManagerTests
//
//  Created by Shing Yien on 18/11/2020.
//

import XCTest
@testable import CommentsManager

class CommentsManagerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFilterCommentsByName() throws {
        let apiResult = [
            Comment(postId: 1, id: 1, name: "First Last", email: "abc@email.com", body: "test"),
            Comment(postId: 1, id: 2, name: "Name 1", email: "efg@email.com", body: "test"),
            Comment(postId: 1, id: 3, name: "Name 2", email: "hij@email.com", body: "test")
        ]
        
        let expectedResult = [apiResult[0]]
        
        testFilterComments(apiResult: apiResult, expectedResult: expectedResult, searchText: "first last")
    }
    
    func testFilterCommentsByEmail() throws {
        let apiResult = [
            Comment(postId: 1, id: 1, name: "First Last", email: "abc@email.com", body: "content 1"),
            Comment(postId: 1, id: 2, name: "Name 1", email: "efg@email.com", body: "content 2"),
            Comment(postId: 1, id: 3, name: "Name 2", email: "abc@email.com", body: "content 3")
        ]
        
        let expectedResult = [apiResult[0], apiResult[2]]
        
        testFilterComments(apiResult: apiResult, expectedResult: expectedResult, searchText: "AbC")
    }
    
    func testFilterCommentsByBody() throws {
        let apiResult = [
            Comment(postId: 1, id: 1, name: "First Last", email: "abc@email.com", body: "content 1"),
            Comment(postId: 1, id: 2, name: "Name 1", email: "efg@email.com", body: "content 2"),
            Comment(postId: 1, id: 3, name: "Name 2", email: "abc@email.com", body: "content 3")
        ]
        
        let expectedResult = apiResult
        
        testFilterComments(apiResult: apiResult, expectedResult: expectedResult, searchText: "content")
    }
    
    func testFilterComments(apiResult: [Comment], expectedResult: [Comment], searchText: String) {
        let apiService = APIServiceMock()
        apiService.setResult(results: apiResult)
        
        let delegate = CommentListDelegateMock()
        
        let presenter = CommentListPresenter(delegate: delegate, apiService: apiService)
        presenter.fetchPostComments(postId: 1)
        presenter.filterComments(searchText: searchText)
        
        let testResult = delegate.commentResult
        
        XCTAssert(testResult == expectedResult)
    }
    
    class APIServiceMock: APIService {
        var results: [Comment]?
        
        func setResult(results: [Comment]){
            self.results = results
        }
        
        override func fetchPostComments(postId: Int, callback: @escaping (Bool, [Comment]?) -> Void) {
            callback(true, results)
        }
    }
    
    class CommentListDelegateMock: CommentListDelegate {
        var commentResult: [Comment] = []
        
        func showLoading() {}
        func hideLoading() {}
        func fetchDataSucceed(data: [Comment]) {}
        func fetchDataFailed(message: String) {}
        
        func updateComments(filteredComments: [Comment]) {
            self.commentResult = filteredComments
        }
    }
}


