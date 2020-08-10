//
//  ServiceManager.swift
//  GameOfThronesArticlesApp
//
//  Created by Karolczyk, Maciej on 06/08/2020.
//  Copyright © 2020 Karolczyk, Maciej. All rights reserved.
//

import Foundation

class ServiceManager {
    
    static let sharedInstance = ServiceManager()
    
    private init() {}
    
    
    func requestTopArticles(completion: @escaping ([Article]) -> Void, errorBlock: @escaping (String) -> Void) {
        sendRequest(Constants.topArticlesEndpoint, parameters: Constants.getTopArticlesParameters()) { responseData, error in
            guard let responseData = responseData, error == nil else {
                errorBlock(error?.localizedDescription ?? "Unknown error")
                return
            }
//            let movieData = try? JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as? Data
//            let articleModel = try? JSONDecoder().decode([Article].self, from: movieData!["items"] as! Data)
            let responseModel = try? JSONDecoder().decode(ArticlesResponseModel.self, from: responseData)
            guard let articles = responseModel?.articles else {
                errorBlock("Unknown error")
                return
            }
            
            completion(articles)
        }
    }
    
    func requestArticleDetails(articleId:Int, completion:@escaping (ArticleDetails) -> Void, errorBlock: @escaping (String) -> Void) {
        let stringId = String(articleId)
        sendRequest(Constants.articleDetailsEndpoint, parameters: Constants.getArticleDetailsParameters(articleId)) { responseData, error in
            guard let responseData = responseData, error == nil else {
                errorBlock(error?.localizedDescription ?? "Unknown error")
                return
            }
            let responseModel = try? JSONDecoder().decode(ArticleDetailsResponseModel.self, from: responseData)
            guard let articles = responseModel?.articles, let article = articles[stringId] else {
                errorBlock("Unknown error")
                return
            }
            completion(article)
        }
    }
    
    func sendRequest(_ url: String, parameters: [String: String], completion: @escaping (Data?, Error?) -> Void) {
        var components = URLComponents(string: url)!
        components.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        let request = URLRequest(url: components.url!)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                (200 ..< 300) ~= response.statusCode,
                error == nil else {
                    completion(nil, error)
                    return
            }
            completion(data, nil)
        }
        task.resume()
    }
}
