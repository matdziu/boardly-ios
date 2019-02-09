//
//  PickPlaceInteractorImpl.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 08/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift

class PickPlaceInteractorImpl: PickPlaceInteractor {
    
    private let pickPlaceService: PickPlaceService
    private var latestQuery = ""
    
    init(pickPlaceService: PickPlaceService) {
        self.pickPlaceService = pickPlaceService
    }
    
    func fetchSearchResults(query: String) -> Observable<PartialPickPlaceViewState> {
        latestQuery = query
        return pickPlaceService.search(query: query)
            .map { PartialPickPlaceViewState.resultsFetched(searchResults: $0) }
            .catchError({ error -> Observable<PartialPickPlaceViewState> in
                return Observable.just(PartialPickPlaceViewState.errorState(error: error as NSError))
            })
            .filter({ [unowned self] _ in query == self.latestQuery })
    }
}
