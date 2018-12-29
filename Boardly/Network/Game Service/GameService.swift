//
//  GameService.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 29/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift

protocol GameService {
    
    func search(query: String) -> Observable<SearchResponse>
    
    func gameDetails(id: String) -> Observable<DetailsResponse>
}
