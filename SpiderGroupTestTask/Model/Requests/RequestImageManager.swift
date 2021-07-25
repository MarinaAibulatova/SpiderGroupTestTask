//
//  RequestImageManager.swift
//  SpiderGroupTestTask
//
//  Created by Марина Айбулатова on 24.07.2021.
//

import Foundation
import Alamofire

protocol RequestImageManagerDelegate: AnyObject {
    func didFinishFetchImages(images: [ImageModel])
    func didFinishFithError(error: String)
}

class RequestImageManager {
    
    weak var delegate: RequestImageManagerDelegate?
    
    //MARK: - Fetch Images
    func fetchImages() {
        let parametersPath = ["gallery","top","top","day", String(RequestManager.page)]
        let headers: HTTPHeaders = ["Authorization": "Client-ID \(Constans.clientID)"]
        
        let requestManager = RequestManager()
        requestManager.fetchData(pathParameters: parametersPath, headers: headers) { (data, error) in
            if !error.isEmpty {
                self.delegate?.didFinishFithError(error: error)
            }
            
            if let imagesData = data {
                var arrayImage: [ImageModel] = []
                do {
                    let data = try JSONDecoder().decode(GalleryAlbumImagesModel.self, from: imagesData)
                    
                    //create array of images
                    for item in data.data {
                        if item.isAlbum {
                            for image in item.images! {
                                arrayImage.append(image)
                            }
                        }else {
                            let newImage = ImageModel(id: item.id, title: item.title, description: item.description, link: item.link, type: item.type)
                            arrayImage.append(newImage)
                        }
                    }
                    self.delegate?.didFinishFetchImages(images: arrayImage)
                }catch {
                    self.delegate?.didFinishFithError(error: Constans.errormessage)
                }
            }
        }
    }
}
