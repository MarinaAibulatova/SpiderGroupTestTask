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

class ImgurImagesViewControllerViewController: UIViewController, RequestImageManagerDelegate {

    //MARK: - Variables
    @IBOutlet weak var imgurImagesCollectionView: UICollectionView!
    static let cellIdentifier: String = "ImageCell"
    
    private var imagesData: [ImageModel] = []
    private let imageCache = AutoPurgingImageCache()
    private let requestManager = RequestImageManager()
    private var contentManager = ContentManager()

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
       self.imagesData += images
        DispatchQueue.main.async {
            self.imgurImagesCollectionView.reloadData()
        }
    }
    
    func didFinishFithError(error: String) {
        print(error)
    }
 
    //MARK: - Prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showImgurImageView" {
            let controller = segue.destination as? ImgurImageViewController
            if let indexPath = imgurImagesCollectionView.indexPath(for: (sender as! ImgurImageViewCell)) {
                controller?.imgurImage = imagesData[indexPath.section]
                controller?.imageCache = self.imageCache
            }
        }
    }
    
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension ImgurImagesViewControllerViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    //MARK: - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return imagesData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imgurImagesCollectionView.dequeueReusableCell(withReuseIdentifier: ImgurImagesViewControllerViewController.cellIdentifier, for: indexPath) as! ImgurImageViewCell
       
        
        cell.backgroundColor = .white
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.gray.cgColor
        
        cell.imageNameLabel.text = imagesData[indexPath.section].title == nil ? "no title" : imagesData[indexPath.section].title

        switch imagesData[indexPath.section].type! {
        case ContentType.video:
            contentManager.removePlayerFromCell()
            let link = imagesData[indexPath.section].link!
            print(indexPath.section)
            if let player = contentManager.loadVideo(from: link){
                
                contentManager.playerLayer.frame = CGRect(x: 0, y: 0, width: cell.frame.width - 20, height: cell.frame.height - 20)
                cell.layer.addSublayer(contentManager.playerLayer)
            }
        case ContentType.gif:
            cell.imgurImageView.animationImages = UIImageView.fromGif(urlString: imagesData[indexPath.section].link!)
            cell.imgurImageView.startAnimating()
        default:
            if let cachedImage = imageCache.image(withIdentifier: imagesData[indexPath.section].id) {
                cell.imgurImageView.image = cachedImage
            }else {
                contentManager.loadImage(from: imagesData[indexPath.section].link!) { [weak self] (image) in
                    guard let self = self, let image = image else {return}
                    
                    cell.imgurImageView.image = image
                    self.imageCache.add(cell.imgurImageView.image!, withIdentifier: self.imagesData[indexPath.section].id)
                }
            }
        }

        return cell
    }
    
    //MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: view.frame.width - 20, height: view.frame.width - 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets.zero
        }else {
            return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
    }
    
}

//MARK: - UICollectionViewDataSourcePrefetching
extension ImgurImagesViewControllerViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if indexPaths[indexPaths.count-1].section == imagesData.count - 1 {
           print(indexPaths[indexPaths.count-1].section)
            RequestManager.page += 1
            self.requestManager.fetchImages()
        }
    }
    
    
}

