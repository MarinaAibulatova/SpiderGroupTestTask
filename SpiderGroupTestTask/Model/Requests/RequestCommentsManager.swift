//
//  RequestCommentsManager.swift
//  SpiderGroupTestTask
//
//  Created by Марина Айбулатова on 25.07.2021.
//

import Foundation
import Alamofire

protocol RequestCommentManagerDelegate: AnyObject {
    func didFinishedFetchComments(comments: [Comment])
    func didFinishedWithError(error: String)
}

class RequestCommentManager {
    
    weak var delegate: RequestCommentManagerDelegate?
    
    func fetchComments(for imageId: String) {
        let parametersPath = ["gallery",imageId,"comments","top"]
        let headers: HTTPHeaders = ["Authorization": "Client-ID \(Constans.clientID)"]
        
        let requestManager = RequestManager()
        requestManager.fetchData(pathParameters: parametersPath, headers: headers) { (data, error) in
            if !error.isEmpty {
                self.delegate?.didFinishedWithError(error: error)
            }
            if let commentsData = data {
                do {
                    let data = try JSONDecoder().decode(GalleryAlbumCommentsModel.self, from: commentsData)
                    self.delegate?.didFinishedFetchComments(comments: data.data)
                }catch {
                    self.delegate?.didFinishedWithError(error: Constans.errormessage)
                }
            }
        }
    }
}
