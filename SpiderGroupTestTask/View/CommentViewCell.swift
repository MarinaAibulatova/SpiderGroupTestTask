//
//  CommentViewCell.swift
//  SpiderGroupTestTask
//
//  Created by Марина Айбулатова on 25.07.2021.
//

import UIKit

class CommentViewCell: UITableViewCell {
   
    @IBOutlet weak var newLabel: UILabel!
    static let identifier = "commentCell"
    
    //@IBOutlet weak var commentTextView: UITextView!
    
    private let commentTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .center
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.textColor = UIColor.black
        textView.isScrollEnabled = false
    
        return textView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
       super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(commentTextView)
        
        let constraints = [
            commentTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            commentTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            commentTextView.topAnchor.constraint(equalTo: contentView.topAnchor),
            commentTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)]
        
        NSLayoutConstraint.activate(constraints)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setCell(text: String) {
        commentTextView.text = text
    }
}
