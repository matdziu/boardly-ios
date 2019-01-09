//
//  GameServiceImpl.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 30/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import SWXMLHash

class GameServiceImpl: GameService {
    
    func search(query: String) -> Observable<SearchResponse> {
        let resultSubject = PublishSubject<SearchResponse>()
        let parameters: Parameters = ["query" : query]
        Alamofire.request(SEARCH_URL, parameters: parameters)
            .validate()
            .response { response in
                var games: [SearchResult] = []
                guard let data = response.data else {
                    resultSubject.onNext(SearchResponse())
                    return
                }
                let xml = SWXMLHash.parse(data)
                for elem in xml[ITEMS_ELEMENT][ITEM_ELEMENT].all {
                    let itemElement = elem.element
                    let nameElement = elem[NAME_ELEMENT].element
                    let yearPublishedElement = elem[YEAR_PUBLISHED_ELEMENT].element
                    
                    let id = itemElement?.attribute(by: ID_ATTRIBUTE)?.text ?? ""
                    let type = itemElement?.attribute(by: TYPE_ATTRIBUTE)?.text ?? ""
                    let name = nameElement?.attribute(by: VALUE_ATTRIBUTE)?.text ?? ""
                    let yearPublished = yearPublishedElement?.attribute(by: VALUE_ATTRIBUTE)?.text ?? ""
                    
                    games.append(SearchResult(id: id, type: type, name: name, yearPublished: yearPublished))
                }
                resultSubject.onNext(SearchResponse(games: games))
        }
        return resultSubject
    }
    
    func gameDetails(id: String) -> Observable<DetailsResponse> {
        let resultSubject = PublishSubject<DetailsResponse>()
        var detailsUrl = BOARD_GAME_DETAILS_URL
        var gameId = id
        if id.isOfType(type: RPG_TYPE) {
            detailsUrl = RPG_DETAILS_URL
            gameId = id.clearFromType(type: RPG_TYPE)
        }
        let parameters: Parameters = ["id" : gameId]
        Alamofire.request(detailsUrl, parameters: parameters)
            .validate()
            .response { response in
                guard let data = response.data else {
                    resultSubject.onNext(DetailsResponse())
                    return
                }
                let xml = SWXMLHash.parse(data)
                let itemElem = xml[ITEMS_ELEMENT][ITEM_ELEMENT]
                let itemElement = itemElem.element
                let nameElement = itemElem[NAME_ELEMENT][0].element
                let imageElement = itemElem[IMAGE_ELEMENT].element
                
                let id = itemElement?.attribute(by: ID_ATTRIBUTE)?.text ?? ""
                let name = nameElement?.attribute(by: VALUE_ATTRIBUTE)?.text ?? ""
                let image = imageElement?.text ?? ""
                
                resultSubject.onNext(DetailsResponse(game: Game(id: id, name: name, image: image)))
        }
        return resultSubject
    }
}
