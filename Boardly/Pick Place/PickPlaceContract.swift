//
//  PickPlaceContract.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 08/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift

protocol PickPlaceView {
    
    func render(pickPlaceViewState: PickPlaceViewState)
    
    func queryEmitter() -> Observable<String>
}

protocol PickPlaceInteractor {
    
    func fetchSearchResults(query: String) -> Observable<PartialPickPlaceViewState>
}

protocol PickPlaceService {
    
    func search(query: String) -> Observable<[PlaceSearchResult]>
}
