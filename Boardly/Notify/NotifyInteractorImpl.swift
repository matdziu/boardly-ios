//
//  NotifyInteractor.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 24/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift

class NotifyInteractorImpl: NotifyInteractor {
    
    private let gameService: GameService
    private let notifyService: NotifyService
    
    init(gameService: GameService,
         notifyService: NotifyService) {
        self.gameService = gameService
        self.notifyService = notifyService
    }
    
    func fetchGameDetails(gameId: String) -> Observable<PartialNotifyViewState> {
        return gameService.gameDetails(id: gameId)
            .observeOn(MainScheduler.instance)
            .catchErrorJustReturn(DetailsResponse())
            .map({ response in return PartialNotifyViewState.gameDetailsFetched(game: response.game) })
    }
    
    func updateNotifySettings(notifySettings: NotifySettings) -> Observable<PartialNotifyViewState> {
        return notifyService.updateNotifySettings(notifySettings: notifySettings)
            .map({ _ in return PartialNotifyViewState.successSaved })
    }
    
    func fetchNotifySettings() -> Observable<PartialNotifyViewState> {
        return notifyService.fetchNotifySettings()
            .map({ notifySettings in return PartialNotifyViewState.notifySettingsFetched(notifySettings: notifySettings) })
    }
    
    func deleteNotifications() -> Observable<PartialNotifyViewState> {
        return notifyService.deleteNotifications()
            .map({ _ in return PartialNotifyViewState.successDeleted })
    }
}
