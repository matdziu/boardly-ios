//
//  PlayersPresenterTest.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 30/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import Quick
import RxSwift

class PlayersPresenterTest: QuickSpec {
    
    override func spec() {
        super.spec()
        
        let testAcceptedPlayersList = [Player(
            id: "acceptedTestId",
            rating: 5.0)]
        let testEvent = BoardlyEvent(eventId: "testEventId", eventName: "testEventName", gameId: "testGameId")
        
        describe("PlayersPresenter") {
            
            it("when players fetch trigger is emitted accepted list is fetched") {
                let mockPlayersInteractor = MockPlayersInteractor(
                    fetchAcceptedPlayers: Observable.just(PartialPlayersViewState.acceptedList(playersList: testAcceptedPlayersList)),
                    fetchEvent: Observable.just(PartialPlayersViewState.eventFetched(event: testEvent)))
                let playersPresenter = PlayersPresenter(playersInteractor: mockPlayersInteractor)
                let playersViewRobot = PlayersViewRobot(playersPresenter: playersPresenter, eventId: "testEventId")
                playersViewRobot.triggerEventDetailsFetching()
                playersViewRobot.assert(expectedViewStates: [
                    PlayersViewState(),
                    PlayersViewState(eventProgress: true),
                    PlayersViewState(event: testEvent),
                    PlayersViewState(playersProgress: true,
                                     event: testEvent),
                    PlayersViewState(acceptedPlayersList: testAcceptedPlayersList,
                                     event: testEvent)])
            }
            
            it("successful rating sending") {
                let modifiedAcceptedPlayersList = [Player(id: "acceptedTestId", rating: 5.0, ratedOrSelf: true)]
                let mockPlayersInteractor = MockPlayersInteractor(
                    sendRating: Observable.just(PartialPlayersViewState.ratingSent))
                let playersPresenter = PlayersPresenter(playersInteractor: mockPlayersInteractor, initialViewState: PlayersViewState(acceptedPlayersList: testAcceptedPlayersList))
                let playersViewRobot = PlayersViewRobot(playersPresenter: playersPresenter, eventId: "testEventId")
                playersViewRobot.emitRating(rateInput: RateInput(rating: 5, playerId: "acceptedTestId", eventId: "testEventId"))
                playersViewRobot.assert(expectedViewStates: [
                    PlayersViewState(acceptedPlayersList: testAcceptedPlayersList),
                    PlayersViewState(acceptedPlayersList: testAcceptedPlayersList),
                    PlayersViewState(acceptedPlayersList: modifiedAcceptedPlayersList)])
            }
            
            it("successful user kicking") {
                let mockPlayersInteractor = MockPlayersInteractor(
                    fetchAcceptedPlayers: Observable.just(PartialPlayersViewState.kicked),
                    fetchEvent: Observable.just(PartialPlayersViewState.eventFetched(event: testEvent)))
                let playersPresenter = PlayersPresenter(playersInteractor: mockPlayersInteractor)
                let playersViewRobot = PlayersViewRobot(playersPresenter: playersPresenter, eventId: "testEventId")
                playersViewRobot.triggerEventDetailsFetching()
                playersViewRobot.assert(expectedViewStates: [
                    PlayersViewState(),
                    PlayersViewState(eventProgress: true),
                    PlayersViewState(event: testEvent),
                    PlayersViewState(playersProgress: true,
                                     event: testEvent),
                    PlayersViewState(kicked: true)])
            }
            
            it("successful event leaving") {
                let mockPlayersInteractor = MockPlayersInteractor(
                    leaveEvent: Observable.just(PartialPlayersViewState.leftEvent))
                let playersPresenter = PlayersPresenter(playersInteractor: mockPlayersInteractor)
                let playersViewRobot = PlayersViewRobot(playersPresenter: playersPresenter, eventId: "testEventId")
                playersViewRobot.leaveEvent()
                playersViewRobot.assert(expectedViewStates: [
                    PlayersViewState(),
                    PlayersViewState(left: true)])
            }
        }
    }
}
