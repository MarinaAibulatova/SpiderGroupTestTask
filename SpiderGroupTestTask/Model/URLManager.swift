//
//  URLManager.swift
//  SpiderGroupTestTask
//
//  Created by Марина Айбулатова on 23.07.2021.
//

import Foundation
import Alamofire

struct URLManager {
    
    func createURL(with parameters: [String: String] = [:], for path: [String] = []) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.imgur.com"
        urlComponents.path = "/3/"
        
        if path.count > 0 {
            urlComponents.path = addPath(with: path, for: urlComponents.path)
        }
        
        if parameters.count > 0 {
            urlComponents.queryItems = setQuerryItems(with: parameters)
        }
        do {
            let url = try urlComponents.asURL()
            return url
        }catch {
            return nil
        }
    }
    
    func addPath(with parameters: [String], for url: String) -> String {
        var newURL = url
        for item in parameters {
            newURL += "\(item)/"
        }
        return newURL
    }
    
    func setQuerryItems(with parameters: [String: String]) -> [URLQueryItem] {
        let querryItems = parameters.map({ URLQueryItem(name: $0.key, value: $0.value)})
        return querryItems
    }
    
}
