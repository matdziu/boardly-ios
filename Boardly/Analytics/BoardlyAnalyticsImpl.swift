//
//  AnalyticsImpl.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 07/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import FirebaseAnalytics

class BoardlyAnalyticsImpl: BoardlyAnalytics {
    
    func logEventAddedEvent(gameId: String,
                            gameId2: String,
                            gameId3: String,
                            placeLatitude: Double,
                            placeLongitude: Double) {
        Analytics.logEvent(EVENT_ADDED_EVENT, parameters: [
            GAME_ID_PARAM: "\(gameId)\(appendWithAmpersand(gameId: gameId2))\(appendWithAmpersand(gameId: gameId3))",
            LAT_LONG_PARAM: "\(placeLatitude)&\(placeLongitude)"])
    }
    
    private func appendWithAmpersand(gameId: String) -> String {
        if !gameId.isEmpty {
            return "&\(gameId)"
        } else {
            return ""
        }
    }
    
    func logJoinRequestSentEvent() {
        Analytics.logEvent(JOIN_REQUEST_SENT_EVENT, parameters: nil)
    }
    
    func logJoinRequestAcceptedEvent() {
        Analytics.logEvent(JOIN_REQUEST_ACCEPTED_EVENT, parameters: nil)
    }
}
