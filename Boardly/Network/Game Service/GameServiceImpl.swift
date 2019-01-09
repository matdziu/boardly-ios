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
        return Observable.just(DetailsResponse())
    }
}
