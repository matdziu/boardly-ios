//
//  PlayersServiceImpl.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 01/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift

class PlayersServiceImpl: EventDetailsServiceImpl, PlayersService {
    
    var userId: String {
        get {
            return getCurrentUserId()
        }
    }
    
    func getAcceptedPlayers(eventId: String) -> Observable<[Player]> {
        return getPartialPlayersProfiles(databaseReference: getAcceptedPlayersNode(eventId: eventId))
            .flatMap { self.completePlayerProfilesWithRating(partialPlayersList: $0, eventId: eventId) }
    }
    
    func leaveEvent(eventId: String) -> Observable<Bool> {
        return removePlayer(eventId: eventId, playerId: getCurrentUserId())
    }
}
