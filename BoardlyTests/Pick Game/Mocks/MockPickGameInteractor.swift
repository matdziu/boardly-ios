//
//  MockPickGameInteractor.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 31/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import RxSwift

class MockPickGameInteractor: PickGameInteractor {
    
    private var fetchSearchResultsFunctionResult = Observable<PartialPickGameViewState>.empty()
    
    init(fetchSearchResults: Observable<PartialPickGameViewState>) {
        self.fetchSearchResultsFunctionResult = fetchSearchResults
    }
    
    func fetchSearchResults(query: String) -> Observable<PartialPickGameViewState> {
        return fetchSearchResultsFunctionResult
    }
}
