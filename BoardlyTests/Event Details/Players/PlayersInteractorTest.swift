//
//  PlayersInteractorTest.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 30/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import Quick
import Nimble
import RxSwift

class PlayersInteractorTest: QuickSpec {
    
    override func spec() {
        super.spec()
        
        describe("PlayersInteractor") {
            
            let testAcceptedPlayersList = [Player(
                id: "acceptedTestId",
                rating: 5.0,
                ratedOrSelf: true)]
            let testEvent = BoardlyEvent(eventId: "testEventId", eventName: "testEventName", gameId: "testGameId")
            
            it("successful accepted players fetching") {
                let playersInteractor = PlayersInteractorImpl(playersService: MockPlayersService(
                    userId: "acceptedTestId",
                    getAcceptedPlayers: Observable.just(testAcceptedPlayersList)))
                
                let output = try! playersInteractor.fetchAcceptedPlayers(eventId: "testEventId")
                    .toBlocking()
                    .toArray()
                
                expect(output).to(equal([PartialPlayersViewState.acceptedList(playersList: testAcceptedPlayersList)]))
            }
            
            it("successful player kick") {
                let playersInteractor = PlayersInteractorImpl(playersService: MockPlayersService(
                    userId: "testtesttest",
                    getAcceptedPlayers: Observable.just(testAcceptedPlayersList)))
                
                let output = try! playersInteractor.fetchAcceptedPlayers(eventId: "testEventId")
                    .toBlocking()
                    .toArray()
                
                expect(output).to(equal([PartialPlayersViewState.kicked]))
            }
            
            it("sucessful rating sending") {
                let playersInteractor = PlayersInteractorImpl(playersService: MockPlayersService(
                    sendRating: Observable.just(true)))
                
                let output = try! playersInteractor
                    .sendRating(rateInput: RateInput(rating: 2, playerId: "testPlayerId", eventId: "testEventId"))
                    .toBlocking()
                    .toArray()
                
                expect(output).to(equal([PartialPlayersViewState.ratingSent]))
            }
            
            it("successful event fetching") {
                let playersInteractor = PlayersInteractorImpl(playersService: MockPlayersService(
                    fetchEventDetails: Observable.just(testEvent)))
                
                let output = try! playersInteractor
                    .fetchEvent(eventId: "testEventId")
                    .toBlocking()
                    .toArray()
                
                expect(output).to(equal([PartialPlayersViewState.eventFetched(event: testEvent)]))
            }
            
            it("successful player leaving") {
                let playersInteractor = PlayersInteractorImpl(playersService: MockPlayersService(
                    leaveEvent: Observable.just(true)))
                
                let output = try! playersInteractor
                    .leaveEvent(eventId: "testEventId")
                    .toBlocking()
                    .toArray()
                
                expect(output).to(equal([PartialPlayersViewState.leftEvent]))
            }
        }
    }
}
