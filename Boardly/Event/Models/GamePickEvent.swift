//
//  GamePickEvent.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 04/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation

struct GamePickEvent {
    var gameId: String = ""
    var type: GamePickType = .first
}
