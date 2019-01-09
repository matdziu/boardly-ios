//
//  EventInteractorTest.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 04/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import Quick
import Nimble
import RxSwift

class EventInteractorTest: QuickSpec {
    
    override func spec() {
        super.spec()
        
        let testGame = Game(id: "1", name: "Monopoly", image: "path/to/image")
        let detailsResponse = DetailsResponse(game: testGame)
        
        describe("EventInteractor") {
            
            it("successful first game details fetching") {
                let mockGameService = MockGameService(gameDetails: { _ in return Observable.just(detailsResponse) })
                let mockEventService = MockEventService()
                let eventInteractor = EventInteractorImpl(gameService: mockGameService, eventService: mockEventService)
                
                let output = try! eventInteractor.fetchGameDetails(gamePickEvent: GamePickEvent(gameId: "1", type: .first))
                    .toBlocking()
                    .toArray()
                
                expect(output).to(equal([PartialEventViewState.gameDetailsFetched(game: testGame, gamePickType: .first)]))
            }
            
            it("successful second game details fetching") {
                let mockGameService = MockGameService(gameDetails: { _ in return Observable.just(detailsResponse) })
                let mockEventService = MockEventService()
                let eventInteractor = EventInteractorImpl(gameService: mockGameService, eventService: mockEventService)
                
                let output = try! eventInteractor.fetchGameDetails(gamePickEvent: GamePickEvent(gameId: "1", type: .second))
                    .toBlocking()
                    .toArray()
                
                expect(output).to(equal([PartialEventViewState.gameDetailsFetched(game: testGame, gamePickType: .second)]))
            }
            
            it("successful third game details fetching") {
                let mockGameService = MockGameService(gameDetails: { _ in return Observable.just(detailsResponse) })
                let mockEventService = MockEventService()
                let eventInteractor = EventInteractorImpl(gameService: mockGameService, eventService: mockEventService)
                
                let output = try! eventInteractor.fetchGameDetails(gamePickEvent: GamePickEvent(gameId: "1", type: .third))
                    .toBlocking()
                    .toArray()
                
                expect(output).to(equal([PartialEventViewState.gameDetailsFetched(game: testGame, gamePickType: .third)]))
            }
            
            it("game details fetching with error") {
                let testError = NSError(domain: "testDoamin", code: 0, userInfo: [NSLocalizedDescriptionKey : "test"])
                let mockGameService = MockGameService(gameDetails: { _ in return Observable.error(testError) })
                let mockEventService = MockEventService()
                let eventInteractor = EventInteractorImpl(gameService: mockGameService, eventService: mockEventService)
                
                let output = try! eventInteractor.fetchGameDetails(gamePickEvent: GamePickEvent(gameId: "1", type: .first))
                    .toBlocking()
                    .toArray()
                
                expect(output).to(equal([PartialEventViewState.gameDetailsFetched(game: Game(), gamePickType: .first)]))
            }
            
            it("successful event addition") {
                let mockGameService = MockGameService()
                let mockEventService = MockEventService(addEvent: Observable.just(true))
                let eventInteractor = EventInteractorImpl(gameService: mockGameService, eventService: mockEventService)
                
                let output = try! eventInteractor.addEvent(inputData: EventInputData())
                    .toBlocking()
                    .toArray()
                
                expect(output).to(equal([PartialEventViewState.successState]))
            }
            
            it("successful event editing") {
                let mockGameService = MockGameService()
                let mockEventService = MockEventService(editEvent: Observable.just(true))
                let eventInteractor = EventInteractorImpl(gameService: mockGameService, eventService: mockEventService)
                
                let output = try! eventInteractor.editEvent(inputData: EventInputData())
                    .toBlocking()
                    .toArray()
                
                expect(output).to(equal([PartialEventViewState.successState]))
            }
            
            it("successful event deletion") {
                let mockGameService = MockGameService()
                let mockEventService = MockEventService(deleteEvent: Observable.just(true))
                let eventInteractor = EventInteractorImpl(gameService: mockGameService, eventService: mockEventService)
                
                let output = try! eventInteractor.deleteEvent(eventId: "testEventId")
                    .toBlocking()
                    .toArray()
                
                expect(output).to(equal([PartialEventViewState.removedState]))
            }
        }
    }
}
