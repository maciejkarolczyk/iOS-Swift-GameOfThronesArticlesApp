//
//  ArticleDetailViewController.swift
//  GameOfThronesArticlesApp
//
//  Created by Karolczyk, Maciej on 08/08/2020.
//  Copyright © 2020 Karolczyk, Maciej. All rights reserved.
//

import UIKit

protocol ArticleDetailDelegate : AnyObject {
    func didPressFavoriteButton(detailsController:ArticleDetailViewController)
}

class ArticleDetailViewController: BaseViewController {
    
    weak var delegate:ArticleDetailDelegate?
    var articleId: Int?
    var isFavorite: Bool = false {
        didSet {
            setupRightBarButton()
        }
    }
    var detailsModel:ArticleDetails? {
        didSet {
            setupWithDataFromModel()
        }
    }
    
    let contentView:UIView = {
        let content = UIView()
        content.translatesAutoresizingMaskIntoConstraints = false
        return content
    }()
    let scrollView:UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()
    let imageView:UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let urlTextView:UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .systemBackground
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    let titleLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()
    let abstractTextField:UITextView = {
        let abstract = UITextView()
        abstract.isEditable = false
        abstract.isScrollEnabled = false
        abstract.translatesAutoresizingMaskIntoConstraints = false
        return abstract
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        urlTextView.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "favorite_empty"), style: .plain, target: self, action: #selector(onFavoriteButton))
        
        if let articleId = articleId {
            ServiceManager.sharedInstance.requestArticleDetails(articleId: articleId, completion: { article in
                self.detailsModel = article
                self.changeLoading(false)
            }) { errorString in
                self.changeLoading(false)
                DispatchQueue.main.async {
                    Toast.show(message: errorString, controller: self)
                }
            }
        }
    }
    
    override func setupLayout() {
        
        super.setupLayout()
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(abstractTextField)
        contentView.addSubview(urlTextView)
        
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        let height = contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        height.priority = .defaultLow
        height.isActive = true
        
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        imageView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 16).isActive = true
        imageView.trailingAnchor.constraint(greaterThanOrEqualTo: contentView.trailingAnchor, constant:-16).isActive = true
        imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3).isActive = true
        imageView.image = #imageLiteral(resourceName: "placeholder_image")
        
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        abstractTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        abstractTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        abstractTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant:-16).isActive = true
        
        urlTextView.topAnchor.constraint(equalTo: abstractTextField.bottomAnchor, constant: 16).isActive = true
        urlTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24).isActive = true
        urlTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant:-24).isActive = true
        
        
        view.bringSubviewToFront(loading)
    }
    
    func setupWithDataFromModel() {
        guard let article = self.detailsModel else {return}
        let url = article.thumbnail

        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url)
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: data!)
                
            }
        }
        
        DispatchQueue.main.async {
            self.titleLabel.text = article.title
            self.abstractTextField.text = article.abstract
            self.abstractTextField.translatesAutoresizingMaskIntoConstraints = true
            self.abstractTextField.sizeToFit()
            self.abstractTextField.translatesAutoresizingMaskIntoConstraints = false
            
            let attributedString = NSMutableAttributedString(string: Strings.moreInfo)
            attributedString.setAttributes([.link: article.url], range: NSMakeRange(0, attributedString.length))
            self.urlTextView.attributedText = attributedString
            self.urlTextView.isUserInteractionEnabled = true
            self.setupRightBarButton()
        }
    }
    
    func setupRightBarButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: self.isFavorite ? #imageLiteral(resourceName: "favorite_filled") : #imageLiteral(resourceName: "favorite_empty"), style: .plain, target: self, action: #selector(self.onFavoriteButton))
    }
    
    @objc func onFavoriteButton() {
        guard let delegate = delegate else {return}
        delegate.didPressFavoriteButton(detailsController: self)
    }
}

extension ArticleDetailViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "gameofthrones.fandom.com"
        components.path = URL.absoluteString
        guard let finalUrl = components.url else {return false}
        UIApplication.shared.open(finalUrl)
        return true
    }
}
