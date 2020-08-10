//
//  GameOfThronesArticlesAppUITests.swift
//  GameOfThronesArticlesAppUITests
//
//  Created by Karolczyk, Maciej on 06/08/2020.
//  Copyright © 2020 Karolczyk, Maciej. All rights reserved.
//

import XCTest

class GameOfThronesArticlesAppUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        app = XCUIApplication()
        app.launch()
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        app = nil
        try super.tearDownWithError()
    }

    func testNavbarFavoriteButton() throws {
        // given
        let mostPopularGotArticlesNavigationBar = XCUIApplication().navigationBars["Most popular GoT articles"]
        let buttonEmpty = mostPopularGotArticlesNavigationBar.buttons["favorite empty"]
        let buttonFilled = mostPopularGotArticlesNavigationBar.buttons["favorite filled"]
        
        // then
        if buttonEmpty.exists {
          XCTAssertTrue(buttonEmpty.exists)
          XCTAssertFalse(buttonFilled.exists)

          buttonEmpty.tap()
          XCTAssertTrue(buttonFilled.exists)
          XCTAssertFalse(buttonEmpty.exists)
        } else if buttonFilled.exists {
          XCTAssertTrue(buttonFilled.exists)
          XCTAssertFalse(buttonEmpty.exists)

          buttonFilled.tap()
          XCTAssertTrue(buttonEmpty.exists)
          XCTAssertFalse(buttonFilled.exists)
        }
    }
    
    func testCellsCountInTableView() throws {
        //given
        let cellsCount = app.tables.children(matching: .cell).count
        //then
        XCTAssertTrue(cellsCount == 75)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
