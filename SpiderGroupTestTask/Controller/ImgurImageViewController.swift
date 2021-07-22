//
//  ImgurImageViewController.swift
//  SpiderGroupTestTask
//
//  Created by Марина Айбулатова on 23.07.2021.
//

import UIKit

class ImgurImageViewController: UIViewController {
    //MARK: - UI
    
    @IBOutlet weak var imageName: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageDescription: UILabel!
    @IBOutlet weak var tableComments: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ImgurImageViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
}
