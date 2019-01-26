//
//  NotifyInteractorTest.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 24/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import Quick
import Nimble
import RxSwift

class NotifyInteractorTest: QuickSpec {
    
    override func spec() {
        super.spec()
        
        let testGame = Game(id: "testId", name: "testGameName", image: "test/path/to/image")
        let testDetailsResponse = DetailsResponse(game: testGame)
        let testNotifySettings = NotifySettings(radius: 100.0, gameId: "1", gameName: "Monopoly")
        let gameService = MockGameService(gameDetails: { _ in return Observable.just(testDetailsResponse) })
        let notifyService = MockNotifyService(updateNotifySettings: Observable.just(true),
                                              fetchNotifySettings: Observable.just(testNotifySettings),
                                              deleteNotifications: Observable.just(true))
        let notifyInteractor = NotifyInteractorImpl(gameService: gameService, notifyService: notifyService)
        
        describe("NotifyInteractor") {
            
            it("successful game details fetching") {
                let output = try! notifyInteractor.fetchGameDetails(gameId: "testGameId")
                    .toBlocking()
                    .toArray()
                expect(output).to(equal([PartialNotifyViewState.gameDetailsFetched(game: testGame)]))
            }
            
            it("successful notify settings update") {
                let output = try! notifyInteractor.updateNotifySettings(notifySettings: NotifySettings())
                    .toBlocking()
                    .toArray()
                expect(output).to(equal([PartialNotifyViewState.successSaved]))
            }
            
            it("successful notify settings fetch") {
                let output = try! notifyInteractor.fetchNotifySettings()
                    .toBlocking()
                    .toArray()
                expect(output).to(equal([PartialNotifyViewState.notifySettingsFetched(notifySettings: testNotifySettings)]))
            }
            
            it("successful notifications deletion") {
                let output = try! notifyInteractor.deleteNotifications()
                    .toBlocking()
                    .toArray()
                expect(output).to(equal([PartialNotifyViewState.successDeleted]))
            }
        }
    }
}
