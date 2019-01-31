//
//  AdminInteractorTest.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 31/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import Quick
import Nimble
import RxSwift

class AdminInteractorTest: QuickSpec {
    
    override func spec() {
        super.spec()
        
        let testAcceptedPlayersList = [Player(
            id: "acceptedTestId",
            rating: 5.0,
            ratedOrSelf: true)]
        let testPendingPlayersList = [Player(
            id: "pendingTestId",
            rating: 5.0,
            ratedOrSelf: true)]
        let testEvent = BoardlyEvent(eventId: "testEventId", eventName: "testEventName", gameId: "testGameId")
        
        let mockAdminService = MockAdminService(
            getAcceptedPlayers: Observable.just(testAcceptedPlayersList),
            getPendingPlayers: Observable.just(testPendingPlayersList),
            acceptPlayer: Observable.just(true),
            kickPlayer: Observable.just(true),
            sendRating: Observable.just(true),
            fetchEventDetails: Observable.just(testEvent),
            removePlayer: Observable.just(true))
        let adminInteractor = AdminInteractorImpl(adminService: mockAdminService)
        
        describe("AdminInteractor") {
            
            it("successful accepted players fetching") {
                let output = try! adminInteractor.fetchAcceptedPlayers(eventId: "testEventId")
                    .toBlocking()
                    .toArray()
                
                expect(output).to(equal([PartialAdminViewState.acceptedList(playersList: testAcceptedPlayersList)]))
            }
            
            it("successful pending players fetching") {
                let output = try! adminInteractor.fetchPendingPlayers(eventId: "testEventId")
                    .toBlocking()
                    .toArray()
                
                expect(output).to(equal([PartialAdminViewState.pendingList(playersList: testPendingPlayersList)]))
            }
            
            it("successful player accepting") {
                let output = try! adminInteractor.acceptPlayer(eventId: "testEventId", playerId: "testPlayerId")
                    .toBlocking()
                    .toArray()
                
                expect(output).to(equal([PartialAdminViewState.playerAccepted]))
            }
            
            it("successful player kicking") {
                let output = try! adminInteractor.kickPlayer(eventId: "testEventId", playerId: "testPlayerId")
                    .toBlocking()
                    .toArray()
                
                expect(output).to(equal([PartialAdminViewState.playerKicked]))
            }
            
            it("successful rating sending") {
                let output = try! adminInteractor.sendRating(rateInput: RateInput(rating: 5, playerId: "testPlyaerId", eventId: "testEventId"))
                    .toBlocking()
                    .toArray()
                
                expect(output).to(equal([PartialAdminViewState.ratingSent]))
            }
            
            it("successful event fetching") {
                let output = try! adminInteractor.fetchEvent(eventId: "testEventId")
                    .toBlocking()
                    .toArray()
                
                expect(output).to(equal([PartialAdminViewState.eventFetched(event: testEvent)]))
            }
        }
    }
}
