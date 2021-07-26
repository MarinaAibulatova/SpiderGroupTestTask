//
//  ImgurImageViewController.swift
//  SpiderGroupTestTask
//
//  Created by Марина Айбулатова on 23.07.2021.
//

import UIKit
import AlamofireImage

class ImgurImageViewController: UIViewController, RequestCommentManagerDelegate {
    
    //MARK: - UI
    @IBOutlet weak var imageName: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableComments: UITableView!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var imageTextViewDescription: UITextView!
    
    //MARK: - Variables
    private var comments: [Comment] = []
    private let requestManager = RequestCommentManager()
    private var contentManager = ContentManager()
    var imgurImage: ImageModel?
    var imageCache: AutoPurgingImageCache?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let image = imgurImage {
            setUI()
            setConstraints(for: image.type!)
            setValues(for: image)
            
            requestManager.delegate = self
            requestManager.fetchComments(for: image.id)
            
        }
    }
    
    //MARK: - Constraints, setView
    private func setUI() {
        imageName.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        videoView.translatesAutoresizingMaskIntoConstraints = false
        tableComments.translatesAutoresizingMaskIntoConstraints = false
        imageTextViewDescription.translatesAutoresizingMaskIntoConstraints = false
        imageTextViewDescription.isScrollEnabled = false
        
        tableComments.delegate = self
        tableComments.dataSource = self
        tableComments.register(CommentViewCell.self, forCellReuseIdentifier: CommentViewCell.identifier)
        
        imageName.contentMode = .scaleToFill
        imageName.numberOfLines = 2
    }
    private func setConstraints(for imageType: ContentType) {
        imageName.addConstraint(NSLayoutConstraint(item: imageName!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 50))
        
        var constraints: [NSLayoutConstraint] = []
        switch imageType {
        case .video:
            videoView.addConstraint(NSLayoutConstraint(item: videoView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: view.frame.height / 4))
            constraints.append(videoView.leadingAnchor.constraint(equalTo: view.leadingAnchor))
            constraints.append(videoView.trailingAnchor.constraint(equalTo: view.trailingAnchor))
            constraints.append(imageTextViewDescription.topAnchor.constraint(equalTo: videoView.bottomAnchor))
        default:
            imageView.addConstraint(NSLayoutConstraint(item: imageView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: view.frame.height / 4))
            constraints.append(imageTextViewDescription.topAnchor.constraint(equalTo: imageView.bottomAnchor))
        }
       
        constraints.append(tableComments.leadingAnchor.constraint(equalTo: view.leadingAnchor))
        constraints.append(tableComments.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        constraints.append(tableComments.bottomAnchor.constraint(equalTo: view.bottomAnchor))
        constraints.append(tableComments.topAnchor.constraint(equalTo: imageTextViewDescription.bottomAnchor))
        NSLayoutConstraint.activate(constraints)
        
    }
    
    private func setValues(for imgurImage: ImageModel) {
        imageName.text = imgurImage.title == nil ? "no title": imgurImage.title
        imageTextViewDescription.text = imgurImage.description == nil ? "no description": imgurImage.description
        
        if imgurImage.type == ContentType.video {
            if let player = contentManager.loadVideo(from: imgurImage.link!){
            
                contentManager.playerLayer.frame = videoView.layer.bounds
                videoView.layer.addSublayer(contentManager.playerLayer)
                contentManager.playerLayer.videoGravity = .resizeAspectFill
                contentManager.playerLayer.player?.play()
        
            }
        }else if imgurImage.type == ContentType.gif {
            imageView.animationImages = UIImageView.fromGif(urlString: imgurImage.link!)
            imageView.startAnimating()
        }else {
            guard let imageCache = imageCache else {
                return
            }
            if let cachedImage = imageCache.image(withIdentifier: imgurImage.id) {
                imageView.image = cachedImage
            }else {
                contentManager.loadImage(from: imgurImage.link!) { (image) in
                    guard let image = image else {return}
                    self.imageView.image = image
                    self.imageCache?.add(image, withIdentifier: imgurImage.id)
                }
            }
        }
    }
    
    //MARK: - RequestCommentManagerDelegate
    func didFinishedWithError(error: String) {
        print(error)
    }
    
    func didFinishedFetchComments(comments: [Comment]) {
        self.comments += comments
        DispatchQueue.main.async {
            self.tableComments.reloadData()
        }
    }

}

extension ImgurImageViewController: UITableViewDataSource, UITableViewDelegate {
    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableComments.dequeueReusableCell(withIdentifier: CommentViewCell.identifier, for: indexPath) as! CommentViewCell
        cell.setCell(text: comments[indexPath.row].comment)
        return cell
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "The top comments!"
    }
}
