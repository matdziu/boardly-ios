//
//  MockGameService.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 30/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import RxSwift

class MockGameService: GameService {
    
    private var searchFunctionResult = { (query: String) in return Observable<SearchResponse>.empty() }
    private var gameDetailsFunctionResult = { (id: String) in return Observable<DetailsResponse>.empty() }
    
    init(search: @escaping (_ query: String) -> Observable<SearchResponse> = { _ in return Observable<SearchResponse>.empty() },
         gameDetails: @escaping (_ id: String) -> Observable<DetailsResponse> = { _ in return Observable<DetailsResponse>.empty() }) {
        self.searchFunctionResult = search
        self.gameDetailsFunctionResult = gameDetails
    }
    
    func search(query: String) -> Observable<SearchResponse> {
        return searchFunctionResult(query)
    }
    
    func gameDetails(id: String) -> Observable<DetailsResponse> {
        return gameDetailsFunctionResult(id)
    }
}
