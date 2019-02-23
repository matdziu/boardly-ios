//
//  GamesCollectionPresenter.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 23/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift

class GamesCollectionPresenter {
    
    private let gamesCollectionInteractor: GamesCollectionInteractor
    private var disposeBag = DisposeBag()
    private let stateSubject: BehaviorSubject<GamesCollectionViewState>
    private var currentCollectionGames: [CollectionGame] = []
    
    init(gamesCollectionInteractor: GamesCollectionInteractor,
         initialViewState: GamesCollectionViewState = GamesCollectionViewState()) {
        self.gamesCollectionInteractor = gamesCollectionInteractor
        self.stateSubject = BehaviorSubject(value: initialViewState)
    }
    
    func bind(gamesCollectionView: GamesCollectionView, collectionId: String) {
        let initialFetchObservable = gamesCollectionView.initialFetchTriggerEmitter()
            .flatMap { _ in self.gamesCollectionInteractor.fetchGames(collectionId: collectionId).startWith(PartialGamesCollectionViewState.progress) }
            .do(onNext: { partialState in
                switch partialState {
                case .collectionFetched(let gamesList):
                    self.currentCollectionGames = gamesList
                default:
                    print("")
                }
            })
        
        let queryObservable = gamesCollectionView.queryEmitter()
            .map { query -> PartialGamesCollectionViewState in
                let formattedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                let filteredList = self.currentCollectionGames.filter({ game -> Bool in
                    game.name.lowercased().contains(formattedQuery)
                })
                return PartialGamesCollectionViewState.collectionFetched(gamesList: filteredList)
        }
        
        Observable
            .merge([
                initialFetchObservable,
                queryObservable])
            .scan(try! stateSubject.value()) { (viewState: GamesCollectionViewState, partialState: PartialGamesCollectionViewState) -> GamesCollectionViewState in
                return self.reduce(previousState: viewState, partialState: partialState)
            }
            .observeOn(MainScheduler.instance)
            .bind(to: stateSubject)
            .disposed(by: disposeBag)
        
        stateSubject
            .subscribe (onNext: {(viewState: GamesCollectionViewState) in
                gamesCollectionView.render(gamesCollectionViewState: viewState)
            })
            .disposed(by: disposeBag)
    }
    
    func unbind() {
        disposeBag = DisposeBag()
    }
    
    private func reduce(previousState: GamesCollectionViewState, partialState: PartialGamesCollectionViewState) -> GamesCollectionViewState {
        return partialState.reduce(previousState: previousState)
    }
}
