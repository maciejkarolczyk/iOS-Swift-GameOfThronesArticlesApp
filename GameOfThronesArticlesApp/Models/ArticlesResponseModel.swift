//
//  ResponseModel.swift
//  GameOfThronesArticlesApp
//
//  Created by Karolczyk, Maciej on 06/08/2020.
//  Copyright © 2020 Karolczyk, Maciej. All rights reserved.
//

import Foundation

struct ArticlesResponseModel {
  let basepath: String
  let articles: [Article]
  
  init(basepath: String, articles: [Article]) {
    self.basepath = basepath
    self.articles = articles
  }
}

struct Article {
    let id: Int
    let title: String
    let url: URL
    let abstract: String
    let thumbnail: URL
    var isFavorite: Bool = false
    
    init(id: Int, title: String, url: URL, abstract: String, thumbnail: URL) {
        self.id = id
        self.title = title
        self.url = url
        self.abstract = abstract
        self.thumbnail = thumbnail
    }
}

extension Article: Decodable {
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

extension ArticlesResponseModel: Decodable {
  enum MyStructKeys: String, CodingKey { // declaring our keys
    case basepath = "basepath"
    case articles = "items"
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: MyStructKeys.self) // defining our (keyed) container
    let basepath: String = try container.decode(String.self, forKey: .basepath) // extracting the data
    let articles: [Article] = try container.decode([Article].self, forKey: .articles) // extracting the data
    
    self.init(basepath: basepath, articles: articles)
  }
}
