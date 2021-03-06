//
//  BGGConstants.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 09/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

let BGG_URL = "https://www.boardgamegeek.com/xmlapi2"
let SEARCH_URL = "\(BGG_URL)/search?type=boardgame,rpg"
let BOARD_GAME_DETAILS_URL = "\(BGG_URL)/thing?type=boardgame"
let RPG_DETAILS_URL = "\(BGG_URL)/family?type=rpg"

let RPG_TYPE = "rpg"
let BOARD_GAME_TYPE = "boardgame"

let ITEMS_ELEMENT = "items"
let ITEM_ELEMENT = "item"
let YEAR_PUBLISHED_ELEMENT = "yearpublished"
let NAME_ELEMENT = "name"
let IMAGE_ELEMENT = "image"

let ID_ATTRIBUTE = "id"
let TYPE_ATTRIBUTE = "type"
let VALUE_ATTRIBUTE = "value"
