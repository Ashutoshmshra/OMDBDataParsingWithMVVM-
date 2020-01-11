//
//  MoviesListViewModelTests.swift
//  MarsDemoTests
//
//  Created by Mobikasa on 1/10/20.
//  Copyright © 2020 Mars. All rights reserved.
//

import XCTest
@testable import MarsDemo
class MoviesListViewModelTests: XCTestCase {
     
    var movies: Search!
    var attributes =  [String : String]()
    override func setUp() {
         attributes = ["title": "Batman Begins", "year": "2005", "type": "movie", "poster": "https://m.media-amazon.com/images/M/MV5BZmUwNGU2ZmItMmRiNC00MjhlLTg5YWUtODMyNzkxODYzMmZlXkEyXkFqcGdeQXVyNTIzOTk5ODM@._V1_SX300.jpg"]
        movies = Search(title: attributes["title"], year: attributes["year"], type: attributes["type"], poster: attributes["poster"])
    }
    //MARK:- Assign nil to the model
    override func tearDown() {
        movies = nil
    }
   //MARK:- Check test cases
    func testData() {
        // Attributes should not be nil.
               XCTAssertNotNil(movies.title, "Title is nil in MoviesCellDataModel")
               XCTAssertNotNil(movies.year, "Year is nil in MoviesCellDataModel")
               XCTAssertNotNil(movies.type, "MovieType is nil in MoviesCellDataModel")
               XCTAssertNotNil(movies.poster, "Poster is nil in MoviesCellDataModel")
               
               // Test if the attributes have the same desired value as they should have.
               XCTAssertEqual(movies.title, attributes["title"])
               XCTAssertEqual(movies.year, attributes["year"])
               XCTAssertEqual(movies.type, attributes["type"])
               XCTAssertEqual(movies.poster, attributes["poster"])
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
