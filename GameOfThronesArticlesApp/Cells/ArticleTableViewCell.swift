//
//  ArticleTableViewCell.swift
//  GameOfThronesArticlesApp
//
//  Created by Karolczyk, Maciej on 06/08/2020.
//  Copyright © 2020 Karolczyk, Maciej. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

protocol ArticleTableViewCellDelegate:AnyObject {
    func didPressFavoriteButton(cell:ArticleTableViewCell)
}

class ArticleTableViewCell: UITableViewCell {
    
    var articleModel:Article? {
        didSet {
            guard let article = articleModel else {return}
            thumbnail.kf.setImage(with: article.thumbnail)
            self.articleTitleLabel.text = article.title
            self.articleAbstractLabel.text = article.abstract
            favoriteButton.setImage(article.isFavorite ? #imageLiteral(resourceName: "favorite_filled") : #imageLiteral(resourceName: "favorite_empty"), for: .normal)
        }
    }
    let thumbnail = UIImageView()
    let articleTitleLabel = UILabel()
    let articleAbstractLabel = UILabel()
    let favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "favorite_empty"), for: .normal)
        return button
    }()
    weak var delegate:ArticleTableViewCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        thumbnail.backgroundColor = .systemBlue

        thumbnail.translatesAutoresizingMaskIntoConstraints = false
        articleTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        articleAbstractLabel.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        articleAbstractLabel.numberOfLines = 2
        articleAbstractLabel.font = UIFont.systemFont(ofSize: 15)
        favoriteButton.addTarget(self, action: #selector(onFavoriteButton), for: .touchUpInside)

        contentView.addSubview(thumbnail)
        contentView.addSubview(articleTitleLabel)
        contentView.addSubview(articleAbstractLabel)
        contentView.addSubview(favoriteButton)
        
        thumbnail.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        thumbnail.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        thumbnail.widthAnchor.constraint(equalToConstant: 60).isActive = true
        thumbnail.heightAnchor.constraint(equalTo: thumbnail.widthAnchor).isActive = true
        
        articleTitleLabel.topAnchor.constraint(equalTo: thumbnail.topAnchor).isActive = true
        articleTitleLabel.leadingAnchor.constraint(equalTo: thumbnail.trailingAnchor, constant: 8).isActive = true
        articleTitleLabel.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -8).isActive = true
        
        articleAbstractLabel.topAnchor.constraint(equalTo: articleTitleLabel.bottomAnchor, constant: 8).isActive = true
        articleAbstractLabel.leadingAnchor.constraint(equalTo: thumbnail.trailingAnchor, constant: 8).isActive = true
        articleAbstractLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        articleAbstractLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
        
        favoriteButton.topAnchor.constraint(equalTo: thumbnail.topAnchor).isActive = true
        favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        favoriteButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        favoriteButton.heightAnchor.constraint(equalTo: favoriteButton.widthAnchor).isActive = true
        
    }
    
    func changeAbstractLength(shouldExpand:Bool) {
        articleAbstractLabel.numberOfLines = shouldExpand ? 0 : 2
    }
    
    @objc private func onFavoriteButton(sender: UIButton!) {
        guard let delegate = delegate else {return}
        delegate.didPressFavoriteButton(cell:self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
