//
//  Analytics.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 07/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

protocol BoardlyAnalytics {
    
    func logEventAddedEvent(gameId: String,
                            gameId2: String,
                            gameId3: String,
                            placeLatitude: Double,
                            placeLongitude: Double)
    
    func logJoinRequestSentEvent()
    
    func logJoinRequestAcceptedEvent()
}
