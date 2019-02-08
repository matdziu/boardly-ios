//
//  MockPickGameInteractor.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 08/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import RxSwift

class MockPickPlaceInteractor: PickPlaceInteractor {
    
    private var fetchSearchResultsFunctionResult = Observable<PartialPickPlaceViewState>.empty()
    
    init(fetchSearchResults: Observable<PartialPickPlaceViewState>) {
        self.fetchSearchResultsFunctionResult = fetchSearchResults
    }
    
    func fetchSearchResults(query: String) -> Observable<PartialPickPlaceViewState> {
        return fetchSearchResultsFunctionResult
    }
}
