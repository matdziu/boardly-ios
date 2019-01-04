//
//  EventInteractorImpl.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 04/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift

class EventInteractorImpl: EventInteractor {
    
    private let gameService: GameService
    private let eventService: EventService
    
    init(gameService: GameService, eventService: EventService) {
        self.gameService = gameService
        self.eventService = eventService
    }
    
    func fetchGameDetails(gamePickEvent: GamePickEvent) -> Observable<PartialEventViewState> {
        return gameService.gameDetails(id: gamePickEvent.gameId)
            .catchErrorJustReturn(DetailsResponse())
            .map({ detailsResponse  in
                return PartialEventViewState.gameDetailsFetched(game: detailsResponse.game, gamePickType: gamePickEvent.type)
            })
    }
    
    func addEvent(inputData: EventInputData) -> Observable<PartialEventViewState> {
        return eventService.addEvent(inputData: inputData)
            .filter({ return $0 })
            .map({ _ in return PartialEventViewState.successState })
    }
    
    func editEvent(inputData: EventInputData) -> Observable<PartialEventViewState> {
        return eventService.editEvent(inputData: inputData)
            .filter({ return $0 })
            .map({ _ in return PartialEventViewState.successState })
    }
    
    func deleteEvent(eventId: String) -> Observable<PartialEventViewState> {
        return eventService.deleteEvent(eventId: eventId)
            .filter({ return $0 })
            .map({ _ in return PartialEventViewState.removedState })
    }
}
