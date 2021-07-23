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
    
    //MARK: - Fetch Images
    func fetchImages() {
        //MARK: - create url
        let parametersPath = ["galler","top","top","day", String(RequestManager.page)]
        let urlManager = URLManager()
        let url = urlManager.createURL(for: parametersPath)
     
        let headers: HTTPHeaders = ["Authorization": "Client-ID \(Constans.clientID)"]
        
        AF.request(url!, method: .get, headers: headers).responseJSON { (responce) in
            guard let statucCode = responce.response?.statusCode else {return}
            
            if(200...299).contains(statucCode) {
                var arrayImage: [ImageModel] = []
                do {
                    let data = try JSONDecoder().decode(GalleryAlbumImagesModel.self, from: responce.data!)
                    
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
                    print(arrayImage.count)
                    
                }catch {
                    debugPrint(error)
                }
                self.delegate?.didFinishFetchImages(images: arrayImage)
            }else {
                self.delegate?.didFinishFithError(error: Constans.errormessage)
            }
        }
    }
    
}
