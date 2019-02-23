//
//  GamesCollectionServiceImpl.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 23/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift
import FirebaseDatabase

class GamesCollectionServiceImpl: BaseServiceImpl, GamesCollectionService {
    
    func fetchGames(collectionId: String) -> Observable<[CollectionGame]> {
        let resultSubject = PublishSubject<[CollectionGame]>()
        
        getSingleCollectionRef(collectionId: collectionId).observeSingleEvent(of: .value) { snapshot in
            var gamesCollection: [CollectionGame] = []
            for childSnapshot in snapshot.children {
                let game = CollectionGame(snapshot: childSnapshot as? DataSnapshot ?? DataSnapshot())
                gamesCollection.append(game)
            }
            resultSubject.onNext(gamesCollection)
        }
        
        return resultSubject
    }
}
