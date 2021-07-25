//
//  RequestManager.swift
//  SpiderGroupTestTask
//
//  Created by Марина Айбулатова on 23.07.2021.
//

import Foundation
import Alamofire

protocol RequestManagerDelegate: AnyObject {
    func didFinishFetchImages(images: [ImageModel])
    func didFinishFithError(error: String)
}

class RequestManager {
    static var page: Int = 0
    
    weak var delegate: RequestManagerDelegate?
    
    func fetchData(pathParameters: [String], headers: HTTPHeaders, completionHadler: @escaping (Data?, String) -> Void)  {
        
        let urlManager = URLManager()
        let url = urlManager.createURL(for: pathParameters)
        
        AF.request(url!, method: .get, headers: headers).responseJSON { (responce) in
            guard let statucCode = responce.response?.statusCode
            else {
                completionHadler(nil, Constans.errormessage)
                return}
            if (200...200).contains(statucCode) {
                completionHadler(responce.data, "")
            }else {
                completionHadler(nil, Constans.errormessage)
            }
            
        }
    }
}
