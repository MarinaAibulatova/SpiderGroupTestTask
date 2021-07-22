//
//  ViewController.swift
//  SpiderGroupTestTask
//
//  Created by Марина Айбулатова on 22.07.2021.
//

import UIKit

class ImgurImagesViewControllerViewController: UIViewController {

    //MARK: - Variables
    @IBOutlet weak var imgurImagesCollectionView: UICollectionView!
    static let cellIdentifier: String = "ImageCell"
    
    let testData = Array.init(repeating: UIImage(named: "new"), count: 20)
    
    private let sectionInsets = UIEdgeInsets(
      top: 50.0,
      left: 20.0,
      bottom: 50.0,
      right: 20.0)
    
    private let itemsPerRow: CGFloat = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //loading view
        imgurImagesCollectionView.dataSource = self
        imgurImagesCollectionView.delegate = self
        
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
        cell.imgurImageView.image = testData[indexPath.row]
        cell.imageNameLabel.text = "name"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
            let availableWidth = view.frame.width - paddingSpace
            let widthPerItem = availableWidth / itemsPerRow
            
            return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    
}
