//
//  MockPickPlaceService.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 08/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import RxSwift

class MockPickPlaceService: PickPlaceService {
    
    private var searchResult = { (query: String) in return Observable<[PlaceSearchResult]>.empty() }
    
    init(search: @escaping (_ query: String) -> Observable<[PlaceSearchResult]> = { _ in return Observable<[PlaceSearchResult]>.empty() }) {
        self.searchResult = search
    }
    
    func search(query: String) -> Observable<[PlaceSearchResult]> {
        return searchResult(query)
    }
}
