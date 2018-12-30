//
//  GameServiceImpl.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 30/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift

class GameServiceImpl: GameService {
    
    func search(query: String) -> Observable<SearchResponse> {
        return Observable.just(SearchResponse())
    }
    
    func gameDetails(id: String) -> Observable<DetailsResponse> {
        return Observable.just(DetailsResponse())
    }
}
