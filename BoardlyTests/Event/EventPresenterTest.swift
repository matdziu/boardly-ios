//
//  EventPresenterTest.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 04/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import Quick
import RxSwift

class EventPresenterTest: QuickSpec {
    
    override func spec() {
        super.spec()
        
        let testGame = Game(id: 1, name: "Monopoly", image: "path/to/image")
        var eventViewRobot: EventViewRobot!
        
        beforeEach {
            let mockEventInteractor = MockEventInteractor(addEvent: Observable.just(.successState), editEvent: Observable.just(.successState), deleteEvent: Observable.just(.removedState))
            eventViewRobot = EventViewRobot(eventPresenter: EventPresenter(eventInteractor: mockEventInteractor))
        }
        
        describe("EventPresenter") {
            
            it("first game pick event") {
                let mockEventInteractor = MockEventInteractor(fetchGameDetails: Observable.just(PartialEventViewState.gameDetailsFetched(game: testGame, gamePickType: .first)))
                let eventPresenter = EventPresenter(eventInteractor: mockEventInteractor)
                let eventViewRobot = EventViewRobot(eventPresenter: eventPresenter)
                
                eventViewRobot.pickGame(gamePickEvent: GamePickEvent(gameId: "1", type: .first))
                eventViewRobot.assert(expectedViewStates: [
                    EventViewState(),
                    EventViewState(selectedGameValid: true),
                    EventViewState(selectedGame: testGame)])
            }
            
            it("second game pick event") {
                let mockEventInteractor = MockEventInteractor(fetchGameDetails: Observable.just(PartialEventViewState.gameDetailsFetched(game: testGame, gamePickType: .second)))
                let eventPresenter = EventPresenter(eventInteractor: mockEventInteractor)
                let eventViewRobot = EventViewRobot(eventPresenter: eventPresenter)
                
                eventViewRobot.pickGame(gamePickEvent: GamePickEvent(gameId: "1", type: .second))
                eventViewRobot.assert(expectedViewStates: [
                    EventViewState(),
                    EventViewState(selectedGameValid: true),
                    EventViewState(selectedGame2: testGame)])
            }
            
            it("third game pick event") {
                let mockEventInteractor = MockEventInteractor(fetchGameDetails: Observable.just(PartialEventViewState.gameDetailsFetched(game: testGame, gamePickType: .third)))
                let eventPresenter = EventPresenter(eventInteractor: mockEventInteractor)
                let eventViewRobot = EventViewRobot(eventPresenter: eventPresenter)
                
                eventViewRobot.pickGame(gamePickEvent: GamePickEvent(gameId: "1", type: .third))
                eventViewRobot.assert(expectedViewStates: [
                    EventViewState(),
                    EventViewState(selectedGameValid: true),
                    EventViewState(selectedGame3: testGame)])
            }
            
            it("place pick event") {
                let inputData = EventInputData(eventName: "Let's go", gameId: "1")
                eventViewRobot.addEvent(inputData: inputData)
                eventViewRobot.pickPlace()
                eventViewRobot.assert(expectedViewStates: [
                    EventViewState(),
                    EventViewState(selectedPlaceValid: false),
                    EventViewState(selectedPlaceValid: true)])
            }
            
            it("event name is blank during addition") {
                let inputData = EventInputData(eventName: "  ", gameId: "1", placeName: "Domowka")
                eventViewRobot.addEvent(inputData: inputData)
                eventViewRobot.assert(expectedViewStates: [
                    EventViewState(),
                    EventViewState(eventNameValid: false)])
            }
            
            it("no game is selected during addition") {
                let inputData = EventInputData(eventName: "Let's go", placeName: "Domowka")
                eventViewRobot.addEvent(inputData: inputData)
                eventViewRobot.assert(expectedViewStates: [
                    EventViewState(),
                    EventViewState(selectedGameValid: false)])
            }
            
            it("no place is selected during addition") {
                let inputData = EventInputData(eventName: "Let's go", gameId: "1")
                eventViewRobot.addEvent(inputData: inputData)
                eventViewRobot.assert(expectedViewStates: [
                    EventViewState(),
                    EventViewState(selectedPlaceValid: false)])
            }
            
            it("add event when all fields are valid") {
                let inputData = EventInputData(eventName: "Let's go", gameId: "1", placeName: "Domowka")
                eventViewRobot.addEvent(inputData: inputData)
                eventViewRobot.assert(expectedViewStates: [
                    EventViewState(),
                    EventViewState(progress: true),
                    EventViewState(success: true)])
            }
            
            it("event name is blank during editing") {
                let inputData = EventInputData(eventName: "  ", gameId: "1", placeName: "Domowka")
                eventViewRobot.editEvent(inputData: inputData)
                eventViewRobot.assert(expectedViewStates: [
                    EventViewState(),
                    EventViewState(eventNameValid: false)])
            }
            
            it("no game is selected during editing") {
                let inputData = EventInputData(eventName: "Let's go", placeName: "Domowka")
                eventViewRobot.editEvent(inputData: inputData)
                eventViewRobot.assert(expectedViewStates: [
                    EventViewState(),
                    EventViewState(selectedGameValid: false)])
            }
            
            it("no place is selected during editing") {
                let inputData = EventInputData(eventName: "Let's go", gameId: "1")
                eventViewRobot.editEvent(inputData: inputData)
                eventViewRobot.assert(expectedViewStates: [
                    EventViewState(),
                    EventViewState(selectedPlaceValid: false)])
            }
            
            it("edit event when all fields are valid") {
                let inputData = EventInputData(eventName: "Let's go", gameId: "1", placeName: "Domowka")
                eventViewRobot.editEvent(inputData: inputData)
                eventViewRobot.assert(expectedViewStates: [
                    EventViewState(),
                    EventViewState(progress: true),
                    EventViewState(success: true)])
            }
            
            it("delete event during during editing") {
                eventViewRobot.deleteEvent(eventId: "testEventId")
                eventViewRobot.assert(expectedViewStates: [
                    EventViewState(),
                    EventViewState(removed: true)])
            }
        }
    }
}
