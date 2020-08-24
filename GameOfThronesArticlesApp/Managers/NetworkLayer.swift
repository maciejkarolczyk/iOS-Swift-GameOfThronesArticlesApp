//
//  NetworkLayer.swift
//  GameOfThronesArticlesApp
//
//  Created by Karolczyk, Maciej on 18/08/2020.
//  Copyright © 2020 Karolczyk, Maciej. All rights reserved.
//

import Foundation

typealias NetworkCompletionHandler = (Data?, URLResponse?, Error?) -> Void
typealias ErrorHandler = (String) -> Void

class NetworkLayer {
    static let genericError = "Something went wrong. Please try again later"
    
    func getData<T: Decodable>(urlString: String,
                               parameters: [String : String] = [:],
                               headers: [String : String] = [:],
                               successHandler: @escaping (T) -> Void,
                               errorHandler: @escaping ErrorHandler) {
        
        let completionHandler: NetworkCompletionHandler = { (data, urlResponse, error) in
            if let error = error {
                print(error.localizedDescription)
                errorHandler(NetworkLayer.genericError)
                return
            }
            
            if self.isSuccessCode(urlResponse) {
                guard let data = data else {
                    print("Unable to parse the response in given type \(T.self)")
                    return errorHandler("Unable to parse the response in given type \(T.self)")
                }
                if let responseObject = try? JSONDecoder().decode(T.self, from: data) {
                    successHandler(responseObject)
                    return
                }
            }
            errorHandler(NetworkLayer.genericError)
        }
        
        var components = URLComponents(string: urlString)!
        components.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        var request = URLRequest(url: components.url!)
        
        request.allHTTPHeaderFields = headers
        URLSession.shared.dataTask(with: request,
                                   completionHandler: completionHandler)
            .resume()
    }
    
    private func isSuccessCode(_ statusCode: Int) -> Bool {
        return statusCode >= 200 && statusCode < 300
    }
    
    private func isSuccessCode(_ response: URLResponse?) -> Bool {
        guard let urlResponse = response as? HTTPURLResponse else {
            return false
        }
        return isSuccessCode(urlResponse.statusCode)
    }
}
