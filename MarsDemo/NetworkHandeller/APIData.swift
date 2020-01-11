//
//  APIData.swift
//  MVVMWithAPIDemo
//
//  Created by Ashutosh on 25/12/19.
//  Copyright © 2019 Ashutosh. All rights reserved.
//

import Foundation
enum APIData{
    case repository(page:Int)
}
//MARK:- Base URL Declairations
extension APIData:URLData{
    var baseURL: URL {
        return URL(string: "http://www.omdbapi.com")!
    }
    var path: String {
        switch self {
        case .repository(let page):
            return "/?s=Batman&page=\(page)&apikey=eeefc96f"
            
        }
        
    }
}
