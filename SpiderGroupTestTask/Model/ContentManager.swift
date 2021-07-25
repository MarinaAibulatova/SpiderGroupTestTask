//
//  ContentManager.swift
//  SpiderGroupTestTask
//
//  Created by Марина Айбулатова on 25.07.2021.
//

import Foundation
import UIKit
import AVFoundation

struct ContentManager {

    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    
    init() {
        self.player = AVPlayer()
        self.playerLayer = AVPlayerLayer(player: self.player)
    }
    
    //MARK: - load video, images
    mutating func loadVideo(from link: String) -> AVPlayer? {
        if let url = URL(string: link) {
            let playerItem = AVPlayerItem(url: url)
            self.player.replaceCurrentItem(with: playerItem)
            return player
        }else {
            return nil
        }
    }
    
     func loadImage(from link: String, completion: @escaping (UIImage?) -> ()) {
        DispatchQueue.global().async {
            if let url = URL(string: link) {
                guard let data = try? Data(contentsOf: url) else {
                    return
                }
                let image = UIImage(data: data)
                
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }
    }
    
    mutating func removePlayerFromCell() {
        if self.playerLayer.superlayer != nil {
           self.playerLayer.removeFromSuperlayer()
           self.player.replaceCurrentItem(with: nil)
        }
    }
}

//MARK: - gifs
extension UIImageView {
    
    static func fromGif(urlString: String) -> [UIImage]? {
        let url = URL(string: urlString)
        guard let gifData = try? Data(contentsOf: url!), let source = CGImageSourceCreateWithData(gifData as CFData, nil) else {
            return nil
        }
        
        var images = [UIImage]()
        let imageCount = CGImageSourceGetCount(source)
        
        for i in 0 ..< imageCount {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(UIImage(cgImage: image))
            }
        }
        
        return images
        
    }
}
