//
//  NotifyPresenterTest.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 24/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import Quick
import RxSwift

class NotifyPresenterTest: QuickSpec {
    
    override func spec() {
        super.spec()
        
        let testNotifySettings = NotifySettings(radius: 100.0, gameId: "1", gameName: "Monopoly")
        let testGame = Game(id: "testId", name: "testGameName", image: "test/path/to/image")
        var notifyViewRobot: NotifyViewRobot!
        
        beforeEach {
            let mockNotifyInteractor = MockNotifyInteractor(
                fetchGameDetails: Observable.just(.gameDetailsFetched(game: testGame)),
                updateNotifySettings:  Observable.just(.success),
                fetchNotifySettings:  Observable.just(.notifySettingsFetched(notifySettings: testNotifySettings)),
                deleteNotifications:  Observable.just(.success))
            let notifyPresenter = NotifyPresenter(notifyInteractor: mockNotifyInteractor)
            notifyViewRobot = NotifyViewRobot(notifyPresenter: notifyPresenter)
        }
        
        describe("NotifyPresenter") {
            
            it("successful game fetching") {
                notifyViewRobot.emitGameId(gameId: "testId")
                notifyViewRobot.assert(expectedViewStates: [
                    NotifyViewState(),
                    NotifyViewState(gameImageUrl: "test/path/to/image")])
            }
            
            it("successful notify settings fetching") {
                notifyViewRobot.triggerNotifySettingsFetch(initialized: false)
                notifyViewRobot.triggerNotifySettingsFetch(initialized: true)
                notifyViewRobot.assert(expectedViewStates: [
                    NotifyViewState(),
                    NotifyViewState(progress: true),
                    NotifyViewState(notifySettings: testNotifySettings)])
            }
            
            it("successful notify settings deletion") {
                notifyViewRobot.emitStopNotifications()
                notifyViewRobot.assert(expectedViewStates: [
                    NotifyViewState(),
                    NotifyViewState(progress: true),
                    NotifyViewState(success: true)])
            }
            
            it("place pick event") {
                notifyViewRobot.emitNotifySettings(notifySettings: NotifySettings())
                notifyViewRobot.emitPlacePickEvent()
                notifyViewRobot.assert(expectedViewStates: [
                    NotifyViewState(),
                    NotifyViewState(selectedPlaceValid: false),
                    NotifyViewState(selectedPlaceValid: true)])
            }
            
            context("user updates notify settings") {
                
                it("when no place is picked then show error") {
                    notifyViewRobot.emitNotifySettings(notifySettings: NotifySettings())
                    notifyViewRobot.assert(expectedViewStates: [
                        NotifyViewState(),
                        NotifyViewState(selectedPlaceValid: false)])
                }
                
                it("when place is picked then show success") {
                    notifyViewRobot.emitNotifySettings(notifySettings: NotifySettings(locationName: "Cracow"))
                    notifyViewRobot.assert(expectedViewStates: [
                        NotifyViewState(),
                        NotifyViewState(progress: true),
                        NotifyViewState(success: true)])
                }
            }
        }
    }
}
