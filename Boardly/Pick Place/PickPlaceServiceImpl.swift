//
//  PickPlaceServiceImpl.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 08/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import SwiftyJSON

class PickPlaceServiceImpl: PickPlaceService {
    
    func search(query: String) -> Observable<[PlaceSearchResult]> {
        let resultSubject = PublishSubject<[PlaceSearchResult]>()
        
        let formattedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
            .replacingOccurrences(of: " ", with: "+")
            .noSpecialChars()
        Alamofire.request("https://nominatim.openstreetmap.org/search?q=\(formattedQuery)&format=json", method: .get).responseJSON { response in
            if response.data != nil {
                let json = try? JSON(data: response.data!)
                let itemsArray = json?.array
                if itemsArray != nil {
                    var resultsList: [PlaceSearchResult] = []
                    for jsonItem in itemsArray! {
                        let displayName = jsonItem["display_name"].string ?? ""
                        let lat = jsonItem["lat"].string ?? ""
                        let lon = jsonItem["lon"].string ?? ""
                        let searchResult = PlaceSearchResult(name: displayName, latitude: Double(lat) ?? 0.0, longitude: Double(lon) ?? 0.0)
                        resultsList.append(searchResult)
                    }
                    resultSubject.onNext(resultsList)
                } else {
                    resultSubject.onNext([])
                }
            }
        }
        
        return resultSubject
    }
}
