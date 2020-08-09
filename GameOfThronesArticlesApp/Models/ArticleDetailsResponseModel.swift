//
//  ArticleDetailsResponseModel.swift
//  GameOfThronesArticlesApp
//
//  Created by Karolczyk, Maciej on 08/08/2020.
//  Copyright © 2020 Karolczyk, Maciej. All rights reserved.
//

import Foundation

struct ArticleDetailsResponseModel {
    let basepath: String
    let articles: [String : ArticleDetails]
    
    init(basepath: String, articles: [String : ArticleDetails]) {
        self.basepath = basepath
        self.articles = articles
    }
}

struct ArticleDetails {
    let id: Int
    let title: String
    let url: URL
    let abstract: String
    let thumbnail: URL
    
    init(id: Int, title: String, url: URL, abstract: String, thumbnail: URL) {
        self.id = id
        self.title = title
        self.url = url
        self.abstract = abstract
        self.thumbnail = thumbnail
    }
}

extension ArticleDetails: Decodable {
  enum MyStructKeys: String, CodingKey {
    case id = "id"
    case title = "title"
    case url = "url"
    case abstract = "abstract"
    case thumbnail = "thumbnail"
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: MyStructKeys.self)
    let id: Int = try container.decode(Int.self, forKey: .id)
    let title: String = try container.decode(String.self, forKey: .title)
    let url: URL = try container.decode(URL.self, forKey: .url)
    let abstract: String = try container.decode(String.self, forKey: .abstract)
    let thumbnail: URL = try container.decode(URL.self, forKey: .thumbnail)
    
    self.init(id: id, title: title, url: url, abstract: abstract, thumbnail: thumbnail)
  }
}


extension ArticleDetailsResponseModel: Decodable {
  enum MyStructKeys: String, CodingKey {
    case basepath = "basepath"
    case articles = "items"
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: MyStructKeys.self)
    let basepath: String = try container.decode(String.self, forKey: .basepath)
    let articles: [String : ArticleDetails] = try container.decode([String : ArticleDetails].self, forKey: .articles)
    
    self.init(basepath: basepath, articles: articles)
  }
}
