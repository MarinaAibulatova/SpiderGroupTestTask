//
//  ViewController.swift
//  SpiderGroupTestTask
//
//  Created by Марина Айбулатова on 22.07.2021.
//

import UIKit
import Alamofire
import AlamofireImage
import AVFoundation
import AVKit

class ImgurImagesViewControllerViewController: UIViewController, RequestManagerDelegate {

    //MARK: - Variables
    @IBOutlet weak var imgurImagesCollectionView: UICollectionView!
    static let cellIdentifier: String = "ImageCell"
    
    private var testData: [ImageModel] = []
    private let imageCache = AutoPurgingImageCache()
    private let requestManager = RequestManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //loading view
        imgurImagesCollectionView.dataSource = self
        imgurImagesCollectionView.delegate = self
        imgurImagesCollectionView.prefetchDataSource = self
        
        requestManager.delegate = self
        requestManager.fetchImages()
        
    }
    
    //MARK: - RequestManagerDelegate
    func didFinishFetchImages(images: [ImageModel]) {
       self.testData += images
        DispatchQueue.main.async {
            self.imgurImagesCollectionView.reloadData()
        }
    }
    
    func didFinishFithError(error: String) {
        
    }
    
    //MARK: - load video, images
    private func loadVideo(from link: String, completion: @escaping (AVPlayerLayer?) -> ()) {
        DispatchQueue.global().async {
            if let url = URL(string: link) {
                let player = AVPlayer(url: url)
                let playerLayer = AVPlayerLayer(player: player)
                
                DispatchQueue.main.async {
                    completion(playerLayer)
                }
            }
                
        }
    }
    
    private func loadImage(from link: String, completion: @escaping (UIImage?) -> ()) {
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
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension ImgurImagesViewControllerViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return testData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imgurImagesCollectionView.dequeueReusableCell(withReuseIdentifier: ImgurImagesViewControllerViewController.cellIdentifier, for: indexPath) as! ImgurImageViewCell
       
        
        cell.backgroundColor = .white
        
        cell.imageNameLabel.text = testData[indexPath.section].title == nil ? "no title" : testData[indexPath.section].title

        return cell
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? ImgurImageViewCell else {
            return
        }
        if (cell.layer.sublayers?.count)! > 1 {
            cell.layer.sublayers?.removeLast()
        }
        
        if testData[indexPath.section].type == ContentType.video {
                self.loadVideo(from: testData[indexPath.section].link!) {(playerLayer) in
                    guard let playerLayer = playerLayer else {return}
                    
                    playerLayer.frame = cell.bounds
                    cell.layer.addSublayer(playerLayer)
                }
            
        }else if testData[indexPath.section].type == ContentType.gif {
            cell.imgurImageView.animationImages = UIImageView.fromGif(urlString: testData[indexPath.section].link!)
            cell.imgurImageView.startAnimating()
        }else {
            if let cachedImage = imageCache.image(withIdentifier: testData[indexPath.section].id) {
                cell.imgurImageView.image = cachedImage
            }else {
                self.loadImage(from: testData[indexPath.section].link!) { [weak self] (image) in
                    guard let self = self, let image = image else {return}

                    cell.imgurImageView.image = image
                    self.imageCache.add(cell.imgurImageView.image!, withIdentifier: self.testData[indexPath.section].id)
                }
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: view.frame.width - 20, height: view.frame.width - 20)
    }
    
}

//MARK: - UICollectionViewDataSourcePrefetching
extension ImgurImagesViewControllerViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if indexPaths[indexPaths.count-1].section == testData.count - 1 {
           print(indexPaths[indexPaths.count-1].section)
            RequestManager.page += 1
            self.requestManager.fetchImages()
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
