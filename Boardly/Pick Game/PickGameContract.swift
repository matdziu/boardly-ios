//
//  PickGameContract.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 31/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift

protocol PickGameView {
    
    func render(pickGameViewState: PickGameViewState)
    
    func queryEmitter() -> Observable<String>
}

protocol PickGameInteractor {
    
    func fetchSearchResults(query: String) -> Observable<PartialPickGameViewState>
}
