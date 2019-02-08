//
//  PickPlaceServiceImpl.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 08/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift

class PickPlaceServiceImpl: PickPlaceService {
    
    func search(query: String) -> Observable<[PlaceSearchResult]> {
        return Observable.empty()
    }
}
