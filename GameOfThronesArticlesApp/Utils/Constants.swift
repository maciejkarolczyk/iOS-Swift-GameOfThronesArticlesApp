//
//  Constants.swift
//  GameOfThronesArticlesApp
//
//  Created by Karolczyk, Maciej on 06/08/2020.
//  Copyright © 2020 Karolczyk, Maciej. All rights reserved.
//

import Foundation

struct Constants {
    
    // MARK: Articles
    static let topArticlesEndpoint = "https://gameofthrones.fandom.com/api/v1/Articles/Top"
    static let isArticlesExpanded = "1"
    static let articlesPerRequest = "75"
    static let articlesCategoryParameter = "articles"
    
    static func getTopArticlesParameters() -> [String:String] {
        return ["expand":Constants.isArticlesExpanded,
                "category":Constants.articlesCategoryParameter,
                "limit":Constants.articlesPerRequest]
    }
    
    // MARK: Article details
    static let articleDetailsEndpoint = "https://gameofthrones.fandom.com/api/v1/Articles/Details"
    static let abstractLength = "500"
    static let imageWidth = "300"
    static let imageHeight = "200"
    
    static func getArticleDetailsParameters(_ id:Int) -> [String:String] {
        return ["ids":String(id),
                "abstract":Constants.abstractLength,
                "width":Constants.imageWidth,
                "height":Constants.imageHeight
        ]
    }
}

struct Strings {
    // MARK: Controllers titles
    static let ArticlesTableViewControllerTitle = "Most popular GoT articles"
    
    // MARK: misc Strings
    static let noInternet = "not connected to internet"
    static let articleSetAsFavorite = "article has been set as favorite"
    static let articleSetAsNotFavorite = "article not favorite anymore"
    static let noFavArticles = "No favorite Articles."
    static let noFavArticlesDescription = "add articles to favorite using Stark house emblem."
    static let moreInfo = "...Continue reading on wiki"
}
