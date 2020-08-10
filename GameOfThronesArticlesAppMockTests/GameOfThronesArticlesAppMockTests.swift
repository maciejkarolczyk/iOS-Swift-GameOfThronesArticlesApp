//
//  GameOfThronesArticlesAppMockTests.swift
//  GameOfThronesArticlesAppMockTests
//
//  Created by Karolczyk, Maciej on 09/08/2020.
//  Copyright © 2020 Karolczyk, Maciej. All rights reserved.
//

import XCTest
@testable import GameOfThronesArticlesApp

class GameOfThronesArticlesAppMockTests: XCTestCase {
    
    override func setUpWithError() throws {
        try super.setUpWithError()
    }
    
    override func tearDownWithError() throws {
        super.tearDown()
    }
    
    func test_ArticlesResponseModel_ParsesData() {
        // given
        let decoder = JSONDecoder()
        
        // when
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: "topArticlesTest", ofType: "json")
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)
        let articleResponseModel = try? decoder.decode(ArticlesResponseModel.self, from: data!)
        
        // then
        XCTAssertEqual(articleResponseModel?.articles.count, 2, "Didn't parse 2 items from fake response")
    }
    
    func test_ArticleDetailsResponseModel_ParsesData() {
        // given
        let decoder = JSONDecoder()
        
        // when
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: "articleDetailsTest", ofType: "json")
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)
        let articleDetailsResponseModel = try? decoder.decode(ArticleDetailsResponseModel.self, from: data!)
        
        // then
        XCTAssertEqual(articleDetailsResponseModel?.articles.count, 1, "Didn't parse 2 items from fake response")
    }
    
}
