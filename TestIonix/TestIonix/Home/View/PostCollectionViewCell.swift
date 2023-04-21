//
//  PostCollectionViewCell.swift
//  TestIonix
//
//  Created by Edward Pizzurro on 4/20/23.
//

import Foundation
import UIKit
import AlamofireImage

class PostCollectionViewCell: UICollectionViewCell {
    let imageView = UIImageView()
    let upArrowImage = UIImageView()
    let downArrowImage = UIImageView()
    let commentImage = UIImageView()
    let titleLabel = UILabel()
    let scoreLabel = UILabel()
    let commentsLabel = UILabel()
    
    let generalView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        generalView.backgroundColor = .clear
        generalView.translatesAutoresizingMaskIntoConstraints = false
        generalView.layer.cornerRadius = 10
        generalView.clipsToBounds = true
        generalView.layer.shadowColor = UIColor.black.cgColor
        generalView.layer.shadowOpacity = 0.2
        generalView.layer.shadowOffset = .zero
        generalView.layer.shadowRadius = 10
        generalView.layer.borderWidth = 0.3
        generalView.layer.borderColor = UIColor.gray.cgColor
        contentView.addSubview(generalView)
        
        generalView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        generalView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        generalView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20).isActive = true
        generalView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
        
        generalView.addSubview(imageView)
        generalView.addSubview(titleLabel)
        generalView.addSubview(scoreLabel)
        generalView.addSubview(commentsLabel)
        generalView.addSubview(commentImage)
        generalView.addSubview(upArrowImage)
        generalView.addSubview(downArrowImage)
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .orange
        
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.2
        
        scoreLabel.font = UIFont.systemFont(ofSize: 15)
        scoreLabel.textColor = .gray
        scoreLabel.textAlignment = .center
        scoreLabel.adjustsFontSizeToFitWidth = true
        scoreLabel.minimumScaleFactor = 0.2
        
        commentsLabel.font = UIFont.systemFont(ofSize: 15)
        commentsLabel.textColor = .gray
        commentsLabel.textAlignment = .center
        commentsLabel.adjustsFontSizeToFitWidth = true
        commentsLabel.minimumScaleFactor = 0.2
        
        upArrowImage.image = UIImage(named: "upArrow")?.withRenderingMode(.alwaysTemplate)
        upArrowImage.contentMode = .scaleAspectFit
        upArrowImage.tintColor = .gray
        
        downArrowImage.image = UIImage(named: "downArrow")?.withRenderingMode(.alwaysTemplate)
        downArrowImage.contentMode = .scaleAspectFit
        downArrowImage.tintColor = .gray
        
        commentImage.image = UIImage(named: "comment")?.withRenderingMode(.alwaysTemplate)
        commentImage.contentMode = .scaleAspectFit
        commentImage.tintColor = .gray
    }
    
    func configure(with post: Post) {
        titleLabel.text = post.title
        scoreLabel.text = "\(post.score)"
        commentsLabel.text = "\(post.numComments)"
        
        if let imageURL = URL(string: post.url) {
            imageView.af.setImage(withURL: imageURL)
        }
    }
    
    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        commentsLabel.translatesAutoresizingMaskIntoConstraints = false
        upArrowImage.translatesAutoresizingMaskIntoConstraints = false
        downArrowImage.translatesAutoresizingMaskIntoConstraints = false
        commentImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: generalView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: generalView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: generalView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: generalView.widthAnchor, multiplier: 0.4),
            
            upArrowImage.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            upArrowImage.leadingAnchor.constraint(equalTo: generalView.leadingAnchor, constant: 20),
            upArrowImage.widthAnchor.constraint(equalToConstant: 20),
            upArrowImage.heightAnchor.constraint(equalToConstant: 20),
            
            scoreLabel.topAnchor.constraint(equalTo: upArrowImage.bottomAnchor, constant: 0),
            scoreLabel.centerXAnchor.constraint(equalTo: upArrowImage.centerXAnchor),
            scoreLabel.widthAnchor.constraint(equalToConstant: 25),
            scoreLabel.heightAnchor.constraint(equalToConstant: 20),
            
            downArrowImage.topAnchor.constraint(equalTo: scoreLabel.topAnchor, constant: 20),
            downArrowImage.leadingAnchor.constraint(equalTo: generalView.leadingAnchor, constant: 20),
            downArrowImage.widthAnchor.constraint(equalToConstant: 20),
            downArrowImage.heightAnchor.constraint(equalToConstant: 20),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: upArrowImage.trailingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: generalView.trailingAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(equalTo: downArrowImage.bottomAnchor),
            
            commentImage.bottomAnchor.constraint(equalTo: generalView.bottomAnchor, constant: -10),
            commentImage.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            commentImage.widthAnchor.constraint(equalToConstant: 25),
            commentImage.heightAnchor.constraint(equalToConstant: 25),
            
            commentsLabel.centerYAnchor.constraint(equalTo: commentImage.centerYAnchor, constant: -2),
            commentsLabel.leadingAnchor.constraint(equalTo: commentImage.trailingAnchor, constant: 2),
            commentsLabel.widthAnchor.constraint(equalToConstant: 25),
            commentsLabel.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
}
