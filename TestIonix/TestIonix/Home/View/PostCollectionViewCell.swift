//
//  PostCollectionViewCell.swift
//  TestIonix
//
//  Created by Edward Pizzurro on 4/20/23.
//

import Foundation
import UIKit

class PostCollectionViewCell: UICollectionViewCell {
    let imageView = UIImageView()
    let upArrowImage = UIImageView()
    let downArrowImage = UIImageView()
    let commentImage = UIImageView()
    let titleLabel = UILabel()
    let scoreLabel = UILabel()
    let commentsLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(scoreLabel)
        contentView.addSubview(commentsLabel)
        contentView.addSubview(commentImage)
        contentView.addSubview(upArrowImage)
        contentView.addSubview(downArrowImage)
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .orange
        
        titleLabel.numberOfLines = 0
        titleLabel.text = "Writin a good headline for your advertisement"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        
        scoreLabel.font = UIFont.systemFont(ofSize: 15)
        scoreLabel.text = "32"
        scoreLabel.textColor = .gray
        scoreLabel.textAlignment = .center
        
        commentsLabel.font = UIFont.systemFont(ofSize: 15)
        commentsLabel.text = "43"
        commentsLabel.textColor = .gray
        commentsLabel.textAlignment = .center
        
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
    
    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        commentsLabel.translatesAutoresizingMaskIntoConstraints = false
        upArrowImage.translatesAutoresizingMaskIntoConstraints = false
        downArrowImage.translatesAutoresizingMaskIntoConstraints = false
        commentImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4),
            
            upArrowImage.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            upArrowImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            upArrowImage.widthAnchor.constraint(equalToConstant: 20),
            upArrowImage.heightAnchor.constraint(equalToConstant: 20),
            
            scoreLabel.topAnchor.constraint(equalTo: upArrowImage.bottomAnchor, constant: 0),
            scoreLabel.centerXAnchor.constraint(equalTo: upArrowImage.centerXAnchor),
            scoreLabel.widthAnchor.constraint(equalToConstant: 20),
            scoreLabel.heightAnchor.constraint(equalToConstant: 20),
            
            downArrowImage.topAnchor.constraint(equalTo: scoreLabel.topAnchor, constant: 20),
            downArrowImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            downArrowImage.widthAnchor.constraint(equalToConstant: 20),
            downArrowImage.heightAnchor.constraint(equalToConstant: 20),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: upArrowImage.trailingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(equalTo: downArrowImage.bottomAnchor),
            
            commentImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            commentImage.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            commentImage.widthAnchor.constraint(equalToConstant: 25),
            commentImage.heightAnchor.constraint(equalToConstant: 25),
            
            commentsLabel.centerYAnchor.constraint(equalTo: commentImage.centerYAnchor, constant: -2),
            commentsLabel.leadingAnchor.constraint(equalTo: commentImage.trailingAnchor, constant: 10),
            commentsLabel.widthAnchor.constraint(equalToConstant: 20),
            commentsLabel.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
}
