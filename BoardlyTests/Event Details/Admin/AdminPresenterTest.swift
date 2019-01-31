//
//  AdminPresenterTest.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 31/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import Quick
import RxSwift

class AdminPresenterTest: QuickSpec {
    
    override func spec() {
        super.spec()
        
        let testAcceptedPlayersList = [Player(
            id: "acceptedTestId",
            rating: 5.0)]
        let testPendingPlayersList = [Player(
            id: "pendingTestId",
            rating: 5.0)]
        let testEvent = BoardlyEvent(eventId: "testEventId", eventName: "testEventName", gameId: "testGameId")
        let mockAdminInteractor = MockAdminInteractor(
            fetchAcceptedPlayers: Observable.just(PartialAdminViewState.acceptedList(playersList: testAcceptedPlayersList)),
            fetchPendingPlayers: Observable.just(PartialAdminViewState.pendingList(playersList: testPendingPlayersList)),
            acceptPlayer: Observable.just(PartialAdminViewState.playerAccepted),
            kickPlayer: Observable.just(PartialAdminViewState.playerKicked),
            sendRating: Observable.just(PartialAdminViewState.ratingSent),
            fetchEvent: Observable.just(PartialAdminViewState.eventFetched(event: testEvent)))
        
        describe("AdminPresenter") {
            
            it("when players fetch trigger is emitted, accepted and pending lists are fetched") {
                let adminPresenter = AdminPresenter(adminInteractor: mockAdminInteractor)
                let adminViewRobot = AdminViewRobot(adminPresenter: adminPresenter, eventId: "testEventId")
                adminViewRobot.triggerEventPlayersFetching()
                adminViewRobot.assert(expectedViewStates: [
                    AdminViewState(),
                    AdminViewState(
                        eventProgress: true),
                    AdminViewState(
                        event: testEvent),
                    AdminViewState(
                        pendingProgress: true,
                        event: testEvent),
                    AdminViewState(
                        pendingPlayersList: testPendingPlayersList,
                        event: testEvent),
                    AdminViewState(
                        acceptedProgress: true,
                        pendingPlayersList: testPendingPlayersList,
                        event: testEvent),
                    AdminViewState(
                        acceptedPlayersList: testAcceptedPlayersList,
                        pendingPlayersList: testPendingPlayersList,
                        event: testEvent)])
            }
            
            it("when player is kicked, players list is updated") {
                let adminPresenter = AdminPresenter(adminInteractor: mockAdminInteractor, initialViewState: AdminViewState(acceptedPlayersList: testAcceptedPlayersList))
                let adminViewRobot = AdminViewRobot(adminPresenter: adminPresenter, eventId: "testEventId")
                adminViewRobot.kickPlayer(playerId: "acceptedTestId")
                adminViewRobot.assert(expectedViewStates: [
                    AdminViewState(
                        acceptedPlayersList: testAcceptedPlayersList),
                    AdminViewState(
                        acceptedPlayersList: testAcceptedPlayersList),
                    AdminViewState()])
            }
            
            it("when player is accepted, players list is updated") {
                let adminPresenter = AdminPresenter(adminInteractor: mockAdminInteractor, initialViewState: AdminViewState(pendingPlayersList: testPendingPlayersList))
                let adminViewRobot = AdminViewRobot(adminPresenter: adminPresenter, eventId: "testEventId")
                adminViewRobot.acceptPlayer(playerId: "pendingTestId")
                adminViewRobot.assert(expectedViewStates: [
                    AdminViewState(
                        pendingPlayersList: testPendingPlayersList),
                    AdminViewState(
                        pendingPlayersList: testPendingPlayersList),
                    AdminViewState()])
            }
            
            it("successful rating sending") {
                let modifiedAcceptedPlayersList = [Player(
                    id: "acceptedTestId",
                    rating: 5.0,
                    ratedOrSelf: true)]
                let adminPresenter = AdminPresenter(adminInteractor: mockAdminInteractor, initialViewState: AdminViewState(acceptedPlayersList: testAcceptedPlayersList))
                let adminViewRobot = AdminViewRobot(adminPresenter: adminPresenter, eventId: "testEventId")
                adminViewRobot.emitRating(rateInput: RateInput(rating: 5, playerId: "acceptedTestId", eventId: "testEventId"))
                adminViewRobot.assert(expectedViewStates: [
                    AdminViewState(
                        acceptedPlayersList: testAcceptedPlayersList),
                    AdminViewState(
                        acceptedPlayersList: testAcceptedPlayersList),
                    AdminViewState(
                        acceptedPlayersList: modifiedAcceptedPlayersList)])
            }
        }
    }
}
