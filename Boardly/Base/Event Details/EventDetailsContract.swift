//
//  EventDetailsContract.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 30/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift

protocol EventDetailsView {
    
    func ratingEmitter() -> Observable<RateInput>
    
    func emitRating(rateInput: RateInput)
}

protocol EventDetailsService {
    
    func sendRating(rateInput: RateInput) -> Observable<Bool>
    
    func fetchEventDetails(eventId: String) -> Observable<BoardlyEvent>
    
    func removePlayer(eventId: String, playerId: String) -> Observable<Bool>
}
