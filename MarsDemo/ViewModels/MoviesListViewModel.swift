//
//  MoviewListViewModel.swift
//  MarsDemo
//
//  Created by Mobikasa on 1/8/20.
//  Copyright © 2020 Mars. All rights reserved.
//

import Foundation
class  MoviesListViewModel {
    //MARK:- Variable Declairations
    private var networkManager = NetworkManager()
    private var repos: OMDBDataModel?
    private var repoDataItem: [Search] = [Search]()
    public var formattedTimeString: String?
    private var  totalData:Int = 1
    private var totalPage:Int = 1
    public var lastpagedReached:Bool = false
    
    //MARK:- Parse the URL Data
    func getMoviesResponse(page:Int, completion: (()-> Void)?){
        networkManager.performNetworkTask(endpoint: APIData.repository(page: page), type: OMDBDataModel.self) { [weak self](response) in
            self?.repos =  response
            if page <= self?.totalPage ?? 1 {
                if(page == 1){
                    self?.repoDataItem = (self?.repos!.search)!
                }
                else{
                    let searchData =  self?.repoDataItem
                    self?.repoDataItem = searchData! + (self?.repos!.search)!
                }
                self?.lastpagedReached = false
            }
            else{
                self?.lastpagedReached = true
                return
            }
            completion?()
        }
    }
    //MARK:- total data count
    public var count: Int {
        return repoDataItem.count 
    }
    //MARK:- Check pagination data for the page
    public var isLastPage: Bool {
        return self.lastpagedReached 
    }
    //MARK:- Remove Data from model
    public func removeAllData(){
        repoDataItem.removeAll()
    }
    //MARK:- Calculate total page, Data count in single page.
    public func pageData(){
        totalData = Int(self.repos?.totalResults ?? "1") ?? 1
        totalPage = totalData/(self.repos?.search?.count ?? totalData)
    }
    //MARK:- Data for views
    public func dataAtIndexPath(_ indexPath:IndexPath) -> Search{
        return repoDataItem[indexPath.row]
    }
}
