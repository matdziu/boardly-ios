//
//  FilterContract.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 29/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift

protocol FilterView {
    
    func render(filterViewState: FilterViewState)
    
    func gameIdEmitter() -> Observable<String>
    
    func locationProcessingEmitter() -> Observable<Bool>
}

protocol FilterInteractor {
    
    func fetchGameDetails(gameId: String) -> Observable<PartialFilterViewState>
}
